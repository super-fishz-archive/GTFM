package team.gtfm.server.db;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import team.gtfm.server.bean.Port;

@Repository
public class NetworkManagerDao {
	@Autowired
	SqlSessionFactoryBean sqlSessionFactoryBean;
	
	public List<Port> selectNotUsingIpPort(){
		try(SqlSession sqlSession = sqlSessionFactoryBean.newSqlSession()){
			List<Port> list = sqlSession.selectList("team.gtfm.server.db.ipMapper.notUsingIp");
			return list;
		}
	}
}
