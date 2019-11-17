using System;
using System.Collections.Generic;
using System.Text;
using Oracle.DataAccess.Client;
using Oracle.DataAccess.Types;
using System.Diagnostics;

namespace ConsoleApplication1
{
  class Program
  {
    static OracleConnection connection;

    static String ConnStr(String host, String portno, String sid, String username, String password)
    {
      String connstr = "Data Source = ";
      connstr += "(DESCRIPTION = ";
      connstr += " (ADDRESS_LIST =";
      connstr += " (ADDRESS = (PROTOCOL = TCP) (HOST = " + host + ")"
          + "(PORT = " + portno + ")) )";
      connstr += " (CONNECT_DATA =(SERVICE_NAME = " + sid + ") ));";
      connstr += "User Id=" + username + ";";
      connstr += "password=" + password + ";";
      return (connstr);
    }

    static void executeImmediate(String sqltext)
    {
      OracleCommand oracommand = new OracleCommand(sqltext, connection);
      oracommand.ExecuteNonQuery();
    }

    static void Main(string[] args)
    {
      try
      {
        if (args.Length != 5)
        {
          Console.WriteLine("Usage: OracleDemo hostname port sid username password");
          Console.ReadLine();
          Environment.Exit(1);
        }
        String host = args[0];
        String port = args[1];
        String sid = args[2];
        String username = args[3];
        String password = args[4];

        String connstr = ConnStr(host, port, sid, username, password);
        connection = new OracleConnection();
        connection.ConnectionString = connstr;
        connection.Open();

        int rowCount = 10000;
        int insertCount = 100000;
        setup();
        arrayInsert(insertCount);
        setup();
        inserts(insertCount);
        executeImmediate("begin sys.dbms_stats.gather_table_stats(ownname=>user,tabname=>'DOTNETDEMO'); end; "); 
        flushDb();
        noBindSelect(rowCount);
        flushDb();
        bindSelect(rowCount);
        flushDb();
        fetchRows(64); // One row per fetch
        flushDb();
        fetchRows(6400); // 100 row per fetch
        connection.Close();

        Console.WriteLine("KahPlah!");
      }
      catch (OracleException x)
      {
        Console.WriteLine(x.Message);
      }
      Console.ReadLine();


    }

    static void setup()
    {
      executeImmediate("ALTER SESSION SET SQL_TRACE=TRUE");
      executeImmediate("ALTER SESSION SET tracefile_identifier=dotnetDemo");

      try
      {
        executeImmediate("DROP table DotNetDemo");
      }
      catch (OracleException ex)
      {
        if (ex.Number != 942)
        {
          Console.Write(ex.StackTrace);
          Console.ReadKey();
          Environment.Exit(1);
        }
      }
      executeImmediate("CREATE TABLE DotNetDemo (x number, y number)");

    }

    static void flushDb()
    {
      executeImmediate("ALTER SYSTEM FLUSH SHARED_POOL");
      executeImmediate("ALTER SYSTEM FLUSH BUFFER_CACHE");
    }

    static void inserts(int rowCount)
    {
      // Example of a non-array insert in Oracle. 
      Console.WriteLine("*********************************************");
      Console.WriteLine("insert by row example");

      // Create the command and associate binds 
      OracleTransaction transaction1 = connection.BeginTransaction();
      OracleCommand insertCommand = new OracleCommand(
          "INSERT /*by row*/ INTO DotNetDemo (x,y) VALUES(:xVal,:yVal)", connection);
      OracleParameter xVal = insertCommand.Parameters.Add(":xVal", OracleDbType.Int32);
      OracleParameter yVal = insertCommand.Parameters.Add(":yVal", OracleDbType.Int32);
      insertCommand.Transaction = transaction1;

      Stopwatch watch = new Stopwatch();

      watch.Start();
      // For each row in the array, execute the command 
      int insertCount = 0;
      for (Int32 i = 1; i <= 1000; i++)
      {
        xVal.Value = i;
        yVal.Value = i;
        insertCount += insertCommand.ExecuteNonQuery();
      }
      transaction1.Commit();
      watch.Stop();

      Console.WriteLine("Elapsed ms=" + watch.ElapsedMilliseconds);
      Console.WriteLine(insertCount + " rows inserted");

    }

    static void arrayInsert(int rowCount)
    {
      // Example of an Array insert in Oracle. 
      Console.WriteLine("*********************************************");
      Console.WriteLine("Array insert example");
      Int32[] x_value_array = new Int32[rowCount];
      Int32[] y_value_array = new Int32[rowCount];

      // Create the arrays 
      for (int i = 0; i < rowCount; i++)
      {
        x_value_array[i] = i;
        y_value_array[i] = i;
      }

      Stopwatch watch = new Stopwatch();
      watch.Start();

      OracleTransaction transaction1 = connection.BeginTransaction();
      OracleCommand insertCommand = new OracleCommand(
          "INSERT /*array*/ INTO DotNetDemo (x,y) VALUES(:xVal,:yVal)", connection);
      insertCommand.Transaction = transaction1;

      //define bind parameters for the insert statement 
      OracleParameter x_value_param = insertCommand.Parameters.Add
                          (":xVal", OracleDbType.Int32);
      OracleParameter y_value_param = insertCommand.Parameters.Add
                          (":yVal", OracleDbType.Int32);
      // Assign the bind variables to the parameters
      x_value_param.Value = x_value_array;
      y_value_param.Value = y_value_array;

      // set the number of rows to be inserted
      insertCommand.ArrayBindCount = x_value_array.Length;
      int insertCount = insertCommand.ExecuteNonQuery(); // execute 

      transaction1.Commit();

      watch.Stop();
      Console.WriteLine("Elapsed ms=" + watch.ElapsedMilliseconds);
      Console.WriteLine(insertCount + " rows inserted");

    }

    static void noBindSelect(int rowCount)
    {
      Console.WriteLine("***************************************");
      Console.WriteLine(" non-bind Select example ");
      Int32 sumOfValues = 0;
      Int32[] xvalueList = new Int32[rowCount];
      for (int i = 0; i < rowCount; i++)
      {
        xvalueList[i] = i;
      }

      Stopwatch watch = new Stopwatch();
      watch.Start();

      for (int i = 0; i<xvalueList.Length; i++)
      {

        String sqlText = "SELECT y FROM DotNetDemo WHERE x="
            + xvalueList[i]; 
        OracleCommand sqlCommand = new OracleCommand
            (sqlText, connection);
        // Execute the scalar SQL statement and store results.
        Int32 yval = Convert.ToInt32(sqlCommand.ExecuteScalar());

        sumOfValues += yval;
      }

      watch.Stop();
      Console.WriteLine("Elapsed time=" + watch.ElapsedMilliseconds);
      Console.WriteLine("Sum of values=" + sumOfValues);
    }

    static void bindSelect(int rowCount)
    {
      Console.WriteLine("***************************************");
      Console.WriteLine(" bind Select example ");
      Int32 sumOfValues = 0;
      Int32[] xvalueList = new Int32[rowCount];
      for (int i = 0; i < rowCount; i++)
      {
        xvalueList[i] = i;
      }

      Stopwatch watch = new Stopwatch();
      watch.Start();

      String sqlText = "SELECT y FROM DotNetDemo WHERE x=:xVal";
      OracleCommand sqlCommand = new OracleCommand(sqlText, connection);
      OracleParameter x_value_param = sqlCommand.Parameters.Add
              (":xVal", OracleDbType.Int32);
      for (int i = 0; i < xvalueList.Length; i++)
      {
        x_value_param.Value = xvalueList[i]; 
        // Execute the scalar SQL statement and store results.
        Int32 yval = Convert.ToInt32(sqlCommand.ExecuteScalar());
        sumOfValues += yval;
      }

      watch.Stop();
      Console.WriteLine("Elapsed time=" + watch.ElapsedMilliseconds);
      Console.WriteLine("Sum of values=" + sumOfValues);
    }

    static void fetchRows(int myFetchSize)
    {
      Console.WriteLine("**************************************");
      Console.WriteLine(" fetch rows fetchSize=" + myFetchSize);
      String sqlText = "SELECT /*" + myFetchSize + "*/ x,y FROM DotNetDemo";
      OracleDecimal sumOfValues = 0;

      
      Stopwatch watch = new Stopwatch();
      watch.Start();

      OracleCommand selectStatement = new OracleCommand(sqlText, connection);
      Console.WriteLine("Default fetch size=" + selectStatement.FetchSize); 
      selectStatement.FetchSize = myFetchSize;  //Array size  in bytes
      OracleDataReader selectReader = selectStatement.ExecuteReader();
      Console.WriteLine("RowSize=" + selectStatement.RowSize);
      while (selectReader.Read())
      {
        OracleDecimal x = selectReader.GetOracleDecimal(0);
        OracleDecimal y = selectReader.GetOracleDecimal(1);
        sumOfValues += x;
      }

      selectReader.Close();

      watch.Stop();
      Console.WriteLine("Elapsed ms=" + watch.ElapsedMilliseconds);
      Console.WriteLine("sumOfValues=" + sumOfValues);
    }

  }
}