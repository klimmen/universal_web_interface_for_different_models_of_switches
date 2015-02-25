## Universal Web Interface For different models of Switches (UWIFS)


UWIFS designed to control the switches from different manufacturers and modle through a common web interface.

#### UWIFS produces control devices using protocols:

	* SNMP v.2
	* TelNet

#### In the initial version of the project switcher supports the following models:

	* ZTE ZXR10 2928-SI
	* ZTE ZXR10 2952-SI
	* ZTE ZXR10 2928E
	* ZTE ZXR10 2952E

	* ZyXEL ES-2024
	* ZyXEL ES-3124
	* ZyXEL MES-3528

#### UWIFS capabilities:

 1. Derivation of general information about the device
 ..* Derivation information (device model, frameware version, uptime device, device MAC address, device IP address)
 ..* Ports informations (status up/down, ports uptime, ports descriptions, speed 10/100/1000Mbit/s, bandwidth limits on ports, macaddress limits on ports)
 ..* Vlans informations (vlans names, vlaevice Configurationns ID, vlans configuration for ports)
 ..* Others etc. 
 2. Device configuration
 ..* Ports configuration (up/down, set port description, set port speed, set bandwidth on port, set maclimit on port)
 ..* Vlans configuration (create/delete vlan, edit vlan configuration: add on ports, tag/untag, set pvid for ports)
 ..* Other (configure IP setings,configure access control setings:login, password, SNMP community table)

   