package team.gtfm.server.bean;

public class Router {
	private int seq;
	private String ip;
	private String defaultGateway;
	private String dnsServer;
	private String subnetMask;
	private String physicalRange;
	private int buildingSeq;
	private int roomSeq;
	private String memo;
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getDefaultGateway() {
		return defaultGateway;
	}
	public void setDefaultGateway(String defaultGateway) {
		this.defaultGateway = defaultGateway;
	}
	public String getDnsServer() {
		return dnsServer;
	}
	public void setDnsServer(String dnsServer) {
		this.dnsServer = dnsServer;
	}
	public String getSubnetMask() {
		return subnetMask;
	}
	public void setSubnetMask(String subnetMask) {
		this.subnetMask = subnetMask;
	}
	public String getPhysicalRange() {
		return physicalRange;
	}
	public void setPhysicalRange(String physicalRange) {
		this.physicalRange = physicalRange;
	}
	public int getBuildingSeq() {
		return buildingSeq;
	}
	public void setBuildingSeq(int buildingSeq) {
		this.buildingSeq = buildingSeq;
	}
	public int getRoomSeq() {
		return roomSeq;
	}
	public void setRoomSeq(int roomSeq) {
		this.roomSeq = roomSeq;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	
	
}
