get_service_paths <service-type>

#We are interested in master services.
set service_type "master"
#Get all the paths as a list.
set master_service_paths [get_service_paths $service_type]
#We are interested in the first service in the list.
set master_index 0
#The path of the first master.
set master_path [lindex $master_service_paths $master_index]
#Or condense the above statements into one statement:
set master_path [lindex [get_service_paths master] 0]


set service_type "master"
set claim_path [claim_service $service_type $master_path mylib];#Claims service.

close_service master $claim_path; #Closes the service.