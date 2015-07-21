package team.gtfm.server.bean;

public class RouterStatus {
	private int seq;
	private String ip;
	private String subnetMask;
	private String roomName;
	/**
	 * @return the seq
	 */
	public int getSeq() {
		return seq;
	}
	/**
	 * @param seq the seq to set
	 */
	public void setSeq(int seq) {
		this.seq = seq;
	}
	/**
	 * @return the ip
	 */
	public String getIp() {
		return ip;
	}
	/**
	 * @param ip the ip to set
	 */
	public void setIp(String ip) {
		this.ip = ip;
	}
	/**
	 * @return the subnetMask
	 */
	public String getSubnetMask() {
		return subnetMask;
	}
	/**
	 * @param subnetMask the subnetMask to set
	 */
	public void setSubnetMask(String subnetMask) {
		this.subnetMask = subnetMask;
	}
	/**
	 * @return the roomName
	 */
	public String getRoomName() {
		return roomName;
	}
	/**
	 * @param roomName the roomName to set
	 */
	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}
	
	
}
