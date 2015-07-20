package team.gtfm.server;

import java.io.InputStream;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import team.gtfm.server.db.SqlSessionFactoryBean;

@Configuration
public class AppConfig {
	
	@Bean
	public SqlSessionFactoryBean sqlSessionFactoryBean(){
		try{
			String path = "mybatis-config.xml";
			SqlSessionFactoryBuilder builder = new SqlSessionFactoryBuilder();
			InputStream inputStream = Resources.getResourceAsStream(path);
			SqlSessionFactory factory = builder.build(inputStream);
			
			return new SqlSessionFactoryBean(factory);
			
		}catch(Exception e){
			e.printStackTrace(System.out);
			throw new RuntimeException("SqlSessionFactoryBean Error.");
		}
	}
}
