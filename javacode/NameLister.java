import java.sql.* ;
import java.util.Vector ;
import java.io.File ;
import java.io.FileReader ;
import java.io.BufferedReader ;
import java.io.FileWriter ;
import java.io.BufferedWriter ;
import java.util.regex.Pattern ;
import java.util.StringTokenizer ;

public class NameLister
{
    final String PostgreSQL_JDBC = "org.postgresql.Driver" ;

    final String TABLE_NAME_LIST = "name_list" ;
    final String TABLE_NAME_LIST_SCHEME = "(entry_name character varying (256), cluster_no integer, name character varying (256), lc_name character varying (256))" ;
    final String TABLE_NAME_LIST_COLUMNS = "(entry_name, cluster_no, name, lc_name)" ;

    final String TABLE_NAME_LIST1 = "name_list1" ;
    final String TABLE_NAME_LIST1_COLUMNS = "(entry_name, cluster_no, protein_name, lc_protein_name)" ;
    
    final String TABLE_NAME_LIST2 = "name_list2" ;
    final String TABLE_NAME_LIST2_COLUMNS = "(entry_name, cluster_no, gene_name, lc_gene_name)" ;
        
    final String TABLE_CLUSTER1 = "cluster1" ;
    final String TABLE_CLUSTER1_SCHEME = "(cluster_no integer, entry_name character varying (256))" ;
    final String TABLE_CLUSTER1_COLUMNS = "(cluster_no, entry_name)" ;
         
    private String sAddress ;
    private String sAccount ;
    private String sPassword ;

    private Statement gStatement_state ;
    
    private PreparedStatement gPreparedStatement_state_entry_name ;
    private PreparedStatement gPreparedStatement_state ;
    
    private Vector gVector_gene_names ;
    private Vector gVector_protein_names ;
        
    public NameLister ()
    {
    	try
    	{    	
    	    sAddress = "localhost" ;
    	    sAccount = "remote_adm" ;
    	    sPassword = "protext" ;
    	
    	    gPreparedStatement_state_entry_name = null ;
    	    gPreparedStatement_state = null ;
        }
    	catch (Exception e)
    	{
    	    System.out.println (e.toString ()) ;
    	} 
    }

    public void listing ()
    {
    	try
    	{
    	    File gFile_result = new File ("GeneSymbolTrainingData") ;
    	    FileWriter gFileWriter_result = new FileWriter (gFile_result) ;
    	    BufferedWriter gBufferedWriter_result = new BufferedWriter (gFileWriter_result) ;
    	    
            File gFile_result2 = new File ("GeneNameTrainingData") ;
            FileWriter gFileWriter_result2 = new FileWriter (gFile_result2) ;
            BufferedWriter gBufferedWriter_result2 = new BufferedWriter (gFileWriter_result2) ;

    	    Class.forName (PostgreSQL_JDBC).newInstance () ;
    	    Connection gConnection_con = DriverManager.getConnection ("jdbc:postgresql://localhost/protextj?user=remote_adm&password=protext") ;
    	    gStatement_state = gConnection_con.createStatement () ;
            
            ResultSet gResultSet_result = gStatement_state.executeQuery ("SELECT DISTINCT gene_name FROM gene_name ;") ;
            
            while (gResultSet_result.next ())
            {
                String sGene = gResultSet_result.getString ("gene_name") ;
                String temp [] = sGene.split (" ") ;
                if (temp.length == 1)
                {
                    gBufferedWriter_result.write (sGene + "@yes") ;
                    gBufferedWriter_result.newLine () ;
                }
            }
            
            gResultSet_result = gStatement_state.executeQuery ("SELECT DISTINCT protein_name FROM protein_name ;") ;

            while (gResultSet_result.next ())
            {
                String sProtein = gResultSet_result.getString ("protein_name") ;
                String temp [] = sProtein.split (" ") ;
                if (temp.length == 1)
                {
                    if (sProtein.endsWith ("in"))
                    {
                        gBufferedWriter_result2.write (sProtein + "@yes") ;
                        gBufferedWriter_result2.newLine () ;
                    }
                    else
                    {
                        gBufferedWriter_result.write (sProtein + "@no") ;
                        gBufferedWriter_result.newLine () ;
                    }
                }
            }
                	    
    	    gStatement_state.close () ;
    	    gConnection_con.close () ;
    	    
            gBufferedWriter_result2.close () ;
            gFileWriter_result2.close () ;

            gBufferedWriter_result.close () ;
            gFileWriter_result.close () ; 

        } //end try    	
        catch (Exception e)
        {
            System.out.println (e.toString ()) ;
        }    
    }
    
    public static void main (String args [])
    {    	
        NameLister test_default_constructor = new NameLister () ;
        test_default_constructor.listing () ;                       
    }    
}
