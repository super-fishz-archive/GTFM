package team.gtfm.server.db;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

public class SqlSessionFactoryBean {
	private SqlSessionFactory factory;
	
	public SqlSessionFactoryBean(SqlSessionFactory factory){
		this.factory = factory;
	}
	
	public SqlSession newSqlSession(){
		return factory.openSession();
	}
	
	@Override
	public String toString(){
		return factory.toString() + ", Hello";
	}
	

}
