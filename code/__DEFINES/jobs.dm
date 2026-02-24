//Jobs depatment lists for use in constant expressions
#define JOBS_SECURITY "Captain","Lieutenant","Detective","Ranger","Junior Ranger"
#define JOBS_COMMAND "Governor","Steward","Captain","Quartermaster","Chief Engineer","Biolab Overseer","Research Overseer","Cardinal","Foreman"
#define JOBS_ENGINEERING "Chief Engineer","Engineer","Apprentice","Janitor"
#define JOBS_MEDICAL "Biolab Overseer","Doctor","Chemist","Psychiatrist","Nurse","Paramedic","Resident"
#define JOBS_SCIENCE "Research Overseer","Scientist","Roboticist","Science Intern","Robotics Intern"
#define JOBS_SUPPLY "Quartermaster","Cargo Technician","Mining Technician"
#define JOBS_SERVICE "Bartender","Chef","Gardener","Artist","Journalist"
#define JOBS_CIVILIAN "Colonist", "Visitor"
#define JOBS_CHURCH "Priest", "Cardinal"
#define JOBS_PROSPECTOR "Foreman","Fence","Prospector Specialist","Prospector","Rookie Prospector"
#define JOBS_NONHUMAN "AI","Robot","pAI"
#define JOBS_LODGE "Lodge Hunt Master","Lodge Hunter","Lodge Herbalist",
#define JOBS_INDEPENDENT "Outsider"

#define JOBS_ANTI_HIVEMIND "Captain","Lieutenant","Detective","Ranger","Junior Ranger","Cardinal","Priest","Foreman","Rookie Prospector","Prospector Specialist","Prospector","Steward","AI","Paramedic","Roboticist","Miner"

#define JOURNALIST "Journalist"
#define HOSP "Hospitality Manager"
#define CHEMIST "Chemist"
#define NURSE "Nurse"
#define PARAMEDIC "Paramedic"
#define SALVAGER_NAME "Prospector Specialist"
#define PROSPECTOR_NAME "Prospector"
#define ROOKIE_PROSPECTOR "Rookie Prospector"
#define CREDS "&cent;"

/proc/html_crew_manifest(var/monochrome, var/OOC)
	var/list/dept_data = list(
        list("names" = list(), "header" = DEPARTMENT_COMMAND,   "flag" = COMMAND),
        list("names" = list(), "header" = DEPARTMENT_SECURITY,  "flag" = SECURITY),
        list("names" = list(), "header" = DEPARTMENT_MEDICAL,   "flag" = MEDICAL),
        list("names" = list(), "header" = DEPARTMENT_SCIENCE,   "flag" = SCIENCE),
        list("names" = list(), "header" = DEPARTMENT_CHURCH,    "flag" = CHURCH),
        list("names" = list(), "header" = DEPARTMENT_SUPPLY,    "flag" = FL),
        list("names" = list(), "header" = DEPARTMENT_ENGINEERING, "flag" = ENGINEERING),
        list("names" = list(), "header" = DEPARTMENT_PROSPECTOR, "flag" = PROSPECTORS),
        list("names" = list(), "header" = DEPARTMENT_CIVILIAN,  "flag" = CIVILIAN),
        list("names" = list(), "header" = DEPARTMENT_LODGE,     "flag" = LODGE),
    )

#define DEPARTMENT_GREYSON "Greyson Positronic"

#define ALL_DEPARTMENTS list(DEPARTMENT_COMMAND, DEPARTMENT_MEDICAL, DEPARTMENT_ENGINEERING, DEPARTMENT_SCIENCE, DEPARTMENT_SECURITY, DEPARTMENT_SUPPLY, DEPARTMENT_SERVICE, DEPARTMENT_CIVILIAN, DEPARTMENT_CHURCH, DEPARTMENT_PROSPECTOR, DEPARTMENT_INDEPENDENT)

#define ASTER_DEPARTMENTS list(DEPARTMENT_COMMAND, DEPARTMENT_SUPPLY)

#define JOBS_OVERALL list(JOBS_SECURITY, JOBS_COMMAND, JOBS_ENGINEERING, JOBS_MEDICAL, JOBS_SCIENCE,JOBS_SUPPLY,JOBS_SERVICE,JOBS_CIVILIAN,JOBS_CHURCH,JOBS_PROSPECTOR)

#define JOURNALIST "Journalist"

#define ROOKIE "Rookie Prospector"
