package team.gtfm.server.bean;

public class Port {
	private int seq;
	private int switchSeq;
	private String ip;
	private String subnetMask;
	private String defaultGateway;
	private String dnsServer;
	private String subDnsServer;
	private int pcSeq;
	private String memo;
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public int getSwitchSeq() {
		return switchSeq;
	}
	public void setSwitchSeq(int switchSeq) {
		this.switchSeq = switchSeq;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getSubnetMask() {
		return subnetMask;
	}
	public void setSubnetMask(String subnetMask) {
		this.subnetMask = subnetMask;
	}
	public String getGateway() {
		return defaultGateway;
	}
	public void setGateway(String gateway) {
		this.defaultGateway = gateway;
	}
	public String getDnsServer() {
		return dnsServer;
	}
	public void setDnsServer(String dnsServer) {
		this.dnsServer = dnsServer;
	}
	public String getSubDnsServer() {
		return subDnsServer;
	}
	public void setSubDnsServer(String subDnsServer) {
		this.subDnsServer = subDnsServer;
	}
	public int getPcSeq() {
		return pcSeq;
	}
	public void setPcSeq(int pcSeq) {
		this.pcSeq = pcSeq;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	
	
	
}
