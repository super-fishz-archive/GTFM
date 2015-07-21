package team.gtfm.api.test;

import org.junit.Test;

import team.gtfm.server.db.NetworkManagerDao;

public class PortTest {
	@Test
	public void deletePortTest(){
		NetworkManagerDao dao = new NetworkManagerDao();
		int c = dao.deletePort(1);
		System.out.println(c);
	}
}
