package main

import (
	"database/sql"
	"fmt"
	rand "math/rand"
	"os"
	"time"

	goracle "gopkg.in/goracle.v2"
)

func createTable(db *sql.DB, rows int) string {
	debug := false
	tableName := fmt.Sprintf("bindTest%d", rand.Int())

	sqlText := fmt.Sprintf(`create table %s as 
			SELECT
				level id,'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' x,
				'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' y
			FROM
				DUAL CONNECT BY LEVEL <= %d`, tableName, rows)

	if debug {
		fmt.Println(tableName)
		fmt.Println(sqlText)
	}
	_, err := db.Exec(sqlText)
	if err != nil {
		fmt.Println(err)
		return (" ")
	}
	// warm the cache
	for i := 1; i <= rows; i++ {
		rows, err := db.Query(fmt.Sprintf("SELECT %d FROM %s WHERE id=:1", i, tableName), i)
		if err != nil {
			fmt.Println(err)
		}
		rows.Close()
	}
	return (tableName)

}

func dropTable(db *sql.DB, tableName string) {

	sqlText := fmt.Sprintf(`drop table %s `, tableName)
	_, err := db.Exec(sqlText)
	if err != nil {
		fmt.Println(err)
		return
	}

}

func bindTest(db *sql.DB) {
	// Test with bind variables
	var maxId int = 1000
	tableName := createTable(db, maxId)
	fmt.Println(tableName)
	var startTime = time.Now()
	for i := 1; i <= maxId; i++ {
		rows, err := db.Query(fmt.Sprintf("SELECT * FROM %s WHERE id=:1", tableName), i)
		if err != nil {
			fmt.Println(err)
		}
		rows.Close()
	}
	var endTime = time.Now()
	var elapsed = endTime.Sub(startTime)
	fmt.Printf("Bind variables: %d\n", elapsed)

	startTime = time.Now()
	for i := 1; i <= maxId; i++ {
		rows, err := db.Query(fmt.Sprintf("SELECT * FROM %s WHERE id=%d", tableName, i))
		if err != nil {
			fmt.Println(err)
		}
		rows.Close()
	}
	endTime = time.Now()
	elapsed = endTime.Sub(startTime)
	fmt.Printf("No Bind variables: %d\n", elapsed)
	dropTable(db, tableName)
}

func execQry(db *sql.DB, sqlText string, arraySize int) (int, time.Duration) {
	var arrSize int
	var startTime = time.Now()
	var rowCount = 0
	if arraySize == 0 {
		arrSize = goracle.DefaultFetchRowCount
	} else {
		arrSize = arraySize
	}
	rows, err := db.Query(sqlText, goracle.FetchRowCount(arrSize))
	if err != nil {
		fmt.Println(err)
		return 0, 0
	}
	defer rows.Close()

	for rows.Next() {
		rowCount++
	}
	var endTime = time.Now()
	var elapsed = endTime.Sub(startTime)
	return rowCount, elapsed
}

func execInsert(db *sql.DB, idArray []int, xArray []string, yArray []int, arraySize int) {
	expectedRows := len(idArray)
	_, err := db.Exec("TRUNCATE TABLE insertTest")
	if err != nil {
		fmt.Println(err)
		return
	}
	var startTime = time.Now()

	if arraySize == 0 {

		for i := 0; i < expectedRows; i++ {
			db.Exec("INSERT INTO insertTest (id,x,y) VALUES (:1, :2, :3)", idArray[i], xArray[i], yArray[i])
		}

	} else {
		lowIdx := 0
		highIdx := 0
		for highIdx < expectedRows {
			//fmt.Printf("lo:%d hi:%d\n", lowIdx, highIdx)
			highIdx = min(lowIdx+arraySize, expectedRows)
			idSlice := idArray[lowIdx:highIdx]
			xSlice := xArray[lowIdx:highIdx]
			ySlice := yArray[lowIdx:highIdx]
			_, err := db.Exec("INSERT INTO insertTest (id,x,y) VALUES (:1, :2, :3)", idSlice, xSlice, ySlice)
			if err != nil {
				fmt.Println(err)
				return
			}
			lowIdx = lowIdx + arraySize
		}
	}
	var endTime = time.Now()
	var elapsed = endTime.Sub(startTime)
	fmt.Printf("%d,%d,%d\n", 1, arraySize, elapsed)

	rows, err := db.Query("select COUNT(*) count from insertTest")
	if err != nil {
		fmt.Println("Error running query")
		fmt.Println(err)
		return
	}
	defer rows.Close()

	var count int
	for rows.Next() {

		rows.Scan(&count)
	}
	if count != expectedRows {
		fmt.Printf("Count error: %d\n", count)
	}
}

func min(a int, b int) int {
	if a < b {
		return a
	} else {
		return b
	}
}

func main() {

	if false { // Complains about goracle if I don't do this
		fmt.Println(goracle.DefaultFetchRowCount)
	}

	db, err := sql.Open("goracle", "my_user/MyPassword123@gharrisodb01_high")
	if err != nil {
		fmt.Println(err)
		return
	}
	defer db.Close()
	bindTest(db)

	var arraySizes = [11]int{0, 1, 10, 50, 100, 256, 500, 756, 1000, 5000, 10000}
	var arrSize int

	var sqlText string
	sqlText = "select * from testdata"
	// Warm the cache
	_, _ = execQry(db, sqlText, 5000)

	fmt.Printf("\nArray fetch\n")
	fmt.Printf("arraySize,elapsedTime,rowCount\n")
	for _, arrSize = range arraySizes {
		rowCount, elapsed := execQry(db, sqlText, arrSize)
		fmt.Printf("%d,%d,%d\n", arrSize, elapsed, rowCount)
	}

	// Array insert testing
	const rowsToInsert int = 10000

	var idArray [rowsToInsert]int

	var xArray [rowsToInsert]string
	var yArray [rowsToInsert]int

	for i := 0; i < rowsToInsert; i++ {
		idArray[i] = i
		xArray[i] = "Nonsense data"
		yArray[i] = i
	}
	fmt.Println(goracle.DefaultFetchRowCount)
	fmt.Println("\nArray Insert")
	fmt.Println("arraySize,Elapsed,Rows")
	for _, arrSize := range arraySizes {
		execInsert(db, idArray[0:len(idArray)], xArray[0:len(xArray)], yArray[0:len(yArray)], arrSize)
	}

	os.Exit(0)

}
