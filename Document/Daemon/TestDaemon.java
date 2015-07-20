package testDaemon;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

import org.apache.commons.daemon.Daemon;
import org.apache.commons.daemon.DaemonContext;
import org.apache.commons.daemon.DaemonInitException;
import org.apache.commons.net.telnet.TelnetClient;

public class TestDaemon implements Daemon,Runnable {
    private String status = "";
    Socket clientsoc = null;
    
    ServerSocket ss = null;
    @Override
    public void init(DaemonContext context) throws DaemonInitException,
            Exception {
        System.out.println("init...");
        String[] args = context.getArguments();
        if (args != null) {
            for (String arg : args) {
                System.out.println(arg);
            }
        }	
        status = "INITED";
        ss = new ServerSocket(10000);
        System.out.println("init OK.");
        System.out.println(); 	
    }
 
    @Override
    public void start() {
    	
    	 
    	 try{
    		 System.out.println("접속 대기합니다.");
    		 clientsoc = ss.accept();
    		 System.out.println("새 쓰레드 시작합니다.");
    		 Thread tr = new Thread(this);
    		 tr.start();
    		 
    	 }catch(Exception e){
    		 e.printStackTrace();
    	 }
    	 
    	
        
    }
 
    @Override
    public void stop() throws Exception {
        System.out.println("status: " + status);
        System.out.println("stop...");
        status = "STOPED";
        System.out.println("stop OK.");
        System.out.println();
    }
 
    @Override
    public void destroy() {
        System.out.println("status: " + status);
        System.out.println("destroy...");
        status = "DESTROIED";
        System.out.println("destroy OK.");
        System.out.println();
    }


    @Override
	public void run() {
		// TODO Auto-generated method stub
		BufferedInputStream in;  
	       
    	DataInputStream br =null;
    	//DataOutputStream pw = null;
    	try{
    		br = new DataInputStream(clientsoc.getInputStream());
	    	//pw = new DataOutputStream(clientsoc.getOutputStream());
    		}catch(Exception e){
    			e.printStackTrace();
    		}
		    try{
		    
		    		
	    	String dom = br.readUTF();
		    

	    	System.out.println(dom);
	    	TelnetClient telnet = new TelnetClient();
	    	telnet.connect("127.0.0.1",23);
	    	System.out.println("메세지 전송1");
	    			
	    	in = new BufferedInputStream(telnet.getInputStream());  
	    	PrintWriter outw = new PrintWriter(telnet.getOutputStream());
		    		
	    	
	              
	       readUntil("login:",in); 
	    	outw.println("han\r\n");
	    	outw.flush();
	    	readUntil("Password:",in);
	    	System.out.println("메세지 전송3");
	    	outw.print("gkstmd6100\r\n");
	    	outw.flush();
	    	/*
	    	InputStreamReader inr = new InputStreamReader(telnet.getInputStream());
	    	BufferedReader brc = new BufferedReader(inr);
	    	
	    	String line;
	    	while((line=brc.readLine())!=null){
	    		System.out.println(line);
	    	}
	    	*/	
	    				
	    	telnet.disconnect();
	    	//s.close();
	    	}catch(Exception e){
	    		System.out.println(e);
	    	}
		}
			
		
	public String readUntil(String pattern, BufferedInputStream in) {
			    		
			try {
				char lastChar = pattern.charAt(pattern.length() - 1);
				StringBuffer sb = new StringBuffer();
				char ch = (char)in.read();
				while(true) {
					System.out.print(ch);
					sb.append(ch);
					if(ch == lastChar) {
						if(sb.toString().endsWith(pattern)) {
							System.out.println(" ");
							return sb.toString();
							}
				        }
					ch = (char)in.read();
					}
				} catch (Exception e) {
					System.out.println(e);
				}
				   
				return null;
		}
			
	public void write(String value,PrintStream out) {

		try {
			out.println(value);
			out.flush();
			} catch (Exception e) {
				e.printStackTrace();
				}
		}
}
