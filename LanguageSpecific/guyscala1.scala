/**
 *
 */
package scala1

import java.sql.Connection
import java.sql.ResultSet

import oracle.jdbc.pool.OracleDataSource

object guyscala2 {
  def main(args: Array[String]) {
    if (args.length != 4) {
      println("Arguments username password hostname serviceName")
      System.exit(1)
    }

    val ods = new OracleDataSource()
    ods.setUser(args(0))
    ods.setPassword(args(1))
    ods.setURL("jdbc:oracle:thin:@" + args(2)+":1521/"+args(3))
    val con = ods.getConnection()
    println("Connected")
    val s1=con.createStatement()
    println("fetchsize="+s1.getFetchSize())
   
    /*noBinds(con, 5000)
    yesBinds(con, 5000)*/
    arrayFetch(con, 500) /*
    nonArrayInsert(con, 1000)
    arrayInsert(con, 1000, 100)*/

    println("EOF")
  }
  
  

  def arrayFetch(con: Connection, rows: Int) {
    /*
     * Test various array fetch sizes 
     */
    val s1 = con.createStatement()

    s1.execute("alter session set tracefile_identifier=scala1")
    s1.execute("alter session set events '10046 trace name context forever, level 4'")

    println("fetchSize,Rows,ms")
    val fetchSizeList = List(1000, 500, 200, 100, 50, 20, 10, 5, 2, 1)
    for (fetchSize <- fetchSizeList) {
      s1.execute("alter system flush buffer_cache")
      s1.setFetchSize(fetchSize)
      val startMs = System.currentTimeMillis
      val rs = s1.executeQuery("Select /*fetchsize=" + s1.getFetchSize() + " */ * " +
        "from customers where rownum<= " + rows)
      var count = 0
      while (rs.next()) {
        val c1 = rs.getString(1)
        val c2 = rs.getString(2)
        count += 1
      }
      rs.close()
      val elapsedMs = System.currentTimeMillis - startMs
      println(fetchSize + "," + count + "," + elapsedMs)
    }

  }
  def preFetch(con: Connection, rows: Int) {
    /*
     * Load rows we are looking at into the buffer cache
     */
    val s1 = con.createStatement()
    val rs = s1.executeQuery("Select /*+INDEX(c) */ * from customers  c where cust_id < " + rows)
    var count = 0
    while (rs.next()) { count += 1 }
    rs.close()
    s1.close()

  }
  def noBinds(con: Connection, rows: Int) {
    val s1 = con.createStatement()
    s1.execute("alter system flush buffer_cache")
    s1.execute("alter system flush shared_pool")
    s1.close()
    preFetch(con, rows)
    val startMs = System.currentTimeMillis

    for (cust_id <- 1 to rows) {
      val s1 = con.createStatement()
      s1.execute("UPDATE customers SET cust_valid = 'Y'"
        + " WHERE cust_id = " + cust_id)

      s1.close()
    }

    val elapsedMs = System.currentTimeMillis - startMs
    println("nobind: " + elapsedMs + " ms")
    con.commit()
  }

  def execSQL(con: Connection, sql: String) {
    val s1 = con.createStatement()
    try {

      s1.execute(sql)
    } catch {
      case e: Exception => { println(e.getMessage()) }
    } finally { s1.close() }

  }

  def yesBinds(con: Connection, rows: Int) {
    val s1 = con.createStatement()
    s1.execute("alter system flush buffer_cache")
    s1.execute("alter system flush shared_pool")
    s1.close()
    preFetch(con, rows)
    val startMs = System.currentTimeMillis
    val s2 = con.prepareStatement(
      "UPDATE customers SET cust_valid = 'Y'"
        + " WHERE cust_id = :custId")

    for (cust_id <- 1 to rows) {
      s2.setInt(1, cust_id)
      s2.execute()
    }

    s2.close()
    val elapsedMs = System.currentTimeMillis - startMs
    println("yesbind: " + elapsedMs + " ms")
    con.commit()
  }

  def setupArrayInsert(con: Connection, rows: Int): java.sql.ResultSet = {
    execSQL(con, "drop table arrayinserttest")
    execSQL(con, "Create table arrayinserttest as " +
      "select cust_id,cust_first_name,cust_last_name,cust_street_address" +
      " from customers where rownum<1")
    val s1 = con.createStatement()

    s1.setFetchSize(1000)
    val rs = s1.executeQuery("select * " +
      "from customers where rownum<=" + rows)

    return (rs)
  }

  def nonArrayInsert(con: Connection, rows: Int) {
    val rs = setupArrayInsert(con, rows)
    val insSQL = "INSERT into arrayinsertTest" +
      " (cust_id,cust_first_name,cust_last_name,cust_street_address) " +
      " VALUES(:1,:2,:3,:4)"
    val insStmt = con.prepareStatement(insSQL)
    val startMs = System.currentTimeMillis
    var rowCount = 0
    while (rs.next()) {
      insStmt.setInt(1, rs.getInt(1))
      insStmt.setString(2, rs.getString(2))
      insStmt.setString(3, rs.getString(3))
      insStmt.setString(4, rs.getString(4))
      rowCount += insStmt.executeUpdate()
    }
    val elapsedMs = System.currentTimeMillis - startMs
    println(rowCount + " rows inserted - " + elapsedMs + " ms")
    con.commit()
  }

  def arrayInsert(con: Connection, rows: Int, batchSize: Int) {
    val rs = setupArrayInsert(con, rows)
    val insSQL = "INSERT into arrayinsertTest" +
      " (cust_id,cust_first_name,cust_last_name,cust_street_address) " +
      " VALUES(:1,:2,:3,:4)"
    val insStmt = con.prepareStatement(insSQL)
    val startMs = System.currentTimeMillis
    var rowCount = 0
    while (rs.next()) {
      insStmt.setInt(1, rs.getInt(1))
      insStmt.setString(2, rs.getString(2))
      insStmt.setString(3, rs.getString(3))
      insStmt.setString(4, rs.getString(4))
      insStmt.addBatch()
      rowCount += 1
      if (rowCount % batchSize == 0) {
        insStmt.executeBatch()
      }
    }

    val elapsedMs = System.currentTimeMillis - startMs
    println(rowCount + " rows inserted - " + elapsedMs + " ms")
    con.commit()
  }

}
