/******************** Requests Console - Paperwork Templates ********************/
/** Paperwork templates for Iskhod Outpost.
 * [field] = writable box (pen can write in it later).
 * [signfield] = writable box for signatures; text written in it uses the signature font (distinct style).
 * [date] / [time] = station date and time. Categorized for menu. */

var/global/list/req_console_paperwork_templates = list()
var/global/list/req_console_paperwork_categories = list()
// Category index per template (1-based), same order as req_console_paperwork_templates.
var/global/list/req_console_paperwork_category_of = list()

/proc/init_req_console_paperwork()
	if(length(req_console_paperwork_templates))
		return
	var/list/T = req_console_paperwork_templates
	var/list/CatOf = req_console_paperwork_category_of

	// Category keys: 1=Generic, 2=Heads of Department, 3=Cargo, 4=Facility Director, 5=Medical, 6=Security, 7=R&D, 8=Prospector & Blackshield, 9=Hunters Lodge

	// ------ Generic Paperwork (category 1) ------
	CatOf += 1
	T += list(list("name" = "Incident Report", "content" = {"[center][large][b]ISKHOD OUTPOST QUANTUM ENTANGLEMENT NETWORK[/b][/large][/center]
[center][b]FORM IO-QEN-03[/b][/center]
[center][b]UPPER OUTPOST INCIDENT REPORT[/b][/center]
[center][large][b]QUANTUM ENTANGLEMENT TRANSMISSION[/b][/large][/center]
[b]Date: [/b][date]
[b]Time: [/b][time]
[b]Relevant Department: [/b][field]
[b]Reporter's Name: [/b][field]
[b]Reporter's Rank: [/b][field]
[b]Priority:[/b][field]
[b]Subject: [/b][field]
[b]Reason for Fax:[/b]
[field]
[b]Requested Action:[/b]
[field]
[b]Reporter's signature: [/b][signfield]
[field]
[b]Stamps of applicable authorities below this line.[/b]"}))
	CatOf += 1
	T += list(list("name" = "Paperwork Loss or Damage Report", "content" = {"[center][b][u]PW-42-3 Form:[/u][/b][large] Paperwork loss or damage report[/center][/large]
[br][hr]
[br][b][u]Name/Aliases of losing party:[/u][/b][i]
[br][field][/i]
[br][b][u]Current Job:[/u][/b][i]
[br][field][/i]
[br][b][u]Was the paper lost or damaged?:[/u][/b][i]
[br][field][/i]
[br][b][u]Other involved parties and occupation:[/u][/b][i]
[br][field][/i]
[br][b][u]Other parties culpability in the incident:[/u][/b][i]
[br][field][/i]
[br][b][u]How was the paperwork lost or damaged?:[/u][/b][i]
[br][field][/i]
[br][b][u]What can be done to avoid this occurring again?:[/u][/b][i]
[br][field][/i]
[br][b][u]Head of losing party's department signature:[/u][/b][i][br][signfield][/i][br][hr][i][small]New paperwork requests are governed by fair use policy PW-41.[/i][/small][br]"}))
	CatOf += 1
	T += list(list("name" = "Paperwork Receipt Form", "content" = {"[center]
[b][u]PW-1 Form:[/u][/b][large] Paperwork Receipt of Delivery form[/center][/large][br]
[hr][br]
[b][u]Name/Aliases of receiving party:[/u][/b][i][br]
[field][/i][br]
[b][u]Current Job of receiving party:[/u][/b][i][br]
[field][/i][br]
[b][u]Name/Aliases of sending party:[/u][/b][i][br]
[field][/i][br]
[b][u]Current Job of sending party:[/u][/b][i][br]
[field][/i][br]
[b][u]Paperwork being sent:[/u][/b][i][br]
[field][/i][br]
[b][u]Paperwork sent confirmation:[/u][/b][i][br]
[field][/i][br]
[b][u]Paperwork received confirmation:[/u][/b][i][br]
[field][/i][br]
[b][u]Facility Director receipt processed:[/u][/b][i][br]
[field][/i][br]
[hr]"}))
	CatOf += 1
	T += list(list("name" = "Generic Purchase Receipt", "content" = {"[center][h1][u]Purchase Receipt[/u][/h1][/center]
[b]Seller:[/b] [field][hr]
[b]Buyer:[/b] [field][hr]
[b]Items bought/sold:[/b]
[field]
[field]
[field]
[hr]
[b]Price/trades:[/b]
[field]
[field]
[field]
[hr]
[b]Seller's Signature:[/b] [signfield][br]
[b]Buyer's Signature:[/b] [signfield][br]
[b]Comments:[/b] [field][br]
[b]Transaction happened around [time] on the [date].[/b]"}))

	// ------ Heads of Department (category 2) ------
	CatOf += 2
	T += list(list("name" = "High Council Communication", "content" = {"[center][large][b]ISKHOD OUTPOST QUANTUM ENTANGLEMENT NETWORK[/b][/large][/center]
[center][b]FORM IO-QEN-01:[/b][/center]
[center][b]GENERAL TRANSMISSION[/b][/center]
[center][large][b]QUANTUM ENTANGLEMENT TRANSMISSION[/b][/large][/center]
[hr]
[b]Date: [/b][date]
[b]Time: [/b][field]
[hr]
[b]Origin: [/b]Outpost
[b]Department: [/b][field]
[b]Destination: [/b][field]
[b]Sender's Name: [/b][field]
[b]Sender's Rank: [/b][field]
[hr]
[b]Priority: [/b][field]
[b]Subject: [/b][field]
[hr]
[large][b]Message Body:[/b][/large]
[field]
[hr]
[b]Sender's signature: [/b][signfield]
[b]Signatures of additional authorities:[/b]
[field]
[b]Stamps of applicable authorities below this line.[/b]
[hr]"}))
	CatOf += 2
	T += list(list("name" = "Internal Transmission", "content" = {"[center][h1][u]Internal Transmission[/u][/h1][/center]
[center][small][i]This paper has been transmitted by [field][/i][/small][/center][hr][hr][small]Date: [date]
Time: [time]
Name: [field]
Department: [field]
Position: [field]
Priority: [field]
Subject: [field]
Transmission:[/small]
[field]
[hr][hr][small][i][signfield][/i][/small]"}))
	CatOf += 2
	T += list(list("name" = "Emergency Transmission", "content" = {"[center] [large] [b] EMERGENCY TRANSMISSION [/center] [/large] [/b]
==============================================================
Sender: [field]
Position: [field]
==============================================================
Message: [field]
==============================================================
Signed: [signfield]"}))

	T += list(list("name" = "Personnel Page Request", "content" = {"[center] [h2]PERSONNEL PAGE REQUEST [/h2][small][time] | [date][/small][/center]
[hr][b]Sender's Name:[/b] [field]
[b]Sender's Position:[/b] [field]
[hr][b]Paged Position(s):[/b] [field]
[b]Reason for Page:[/b] [field]
[hr][b]Signed:[/b] [signfield]"}))
	CatOf += 2
	T += list(list("name" = "Employment Sanctions Form", "content" = {"[center][large][b]LC-005 - Sanctions Form[/b][/large][/center][hr]
[b]Name of employee:[/b] [field]
[b]Original position:[/b] [field]
[b]Sanction applied:[/b] [field]
[b]New position (if demotion):[/b][field]
[b]Temporary or Permanent:[/b] [field]
[b]Imposed by:[/b] [field]
[b]Contested (Yes/No):[/b] [field]
[b]Reason for Sanction:[/b]
[field]
[b]Signature of imposing individual(s):[/b]
[signfield]
[b]Stamps of applicable authorities below this line.[/b]
[hr]"}))
	CatOf += 2
	T += list(list("name" = "Staff Assessment Paperwork", "content" = {"[center][b][u]S-112 Form:[/u][/b][large]Shift Departmental Staff Assessment[/center][/large]
[br][hr]
[br][b][u]Department:[/u][/b][i]
[br][field][/i]
[br][b][u]Name of staff member:[/u][/b][i]
[br][field][/i]
[br][b][u]Current Job:[/u][/b][i]
[br][field][/i]
[br][b][u]Current Duties:[/u][/b][i]
[br][field][/i]
[br][b][u]Does the staff member wear the correct uniform and protective gear?:[/u][/b][i]
[br][field][/i]
[br][b][u]Rate the staff members performance between 1 and 10:[/u][/b][i]
[br][field][/i]
[br][b][u]Does the staff member require further training:[/u][/b][i]
[br][field][/i]
[br][b][u]Head of Department:[/u][/b][i]
[br][field][/i]
[br][hr]"}))
	CatOf += 2
	T += list(list("name" = "Tribunal Ruling Form", "content" = {"[center][logo][br][h1]LC-001-TD
[hr]Iskhod Council[br]Tribunal ruling[/h1][hr][/center]
[b][i][small]Pursuant to Outpost Legal Procedure this form shall serve as official record of any and all tribunals.[/b][/i][/small][hr][h3]
Accused Person/persons:[field]
Charges:[field]
Ruling:[field]
Punishment:[field]
Notes:[field]
[hr][/h3]
[b][i][small]All applicable signatures below.[/b][/i][/small][hr]
[table][row][cell]Councilors Title[cell]Councilors Signature[cell]Councilors Vote
[row][cell]Facility Director[cell][signfield][cell][b][field][/b]
[row][cell]Guildmaster[cell][signfield][cell][b][field][/b]
[row][cell]Chief Executive Officer[cell][signfield][cell][b][field][/b]
[row][cell]Chief Biolab Overseer[cell][signfield][cell][b][field][/b]
[row][cell]Chief Research Overseer[cell][signfield][cell][b][field][/b]
[row][cell]Blackshield Commander[cell][signfield][cell][b][field][/b]
[row][cell]Warrant Officer[cell][signfield][cell][b][field][/b]
[row][cell]Prime[cell][signfield][cell][b][field][/b]
[row][cell]Foreman[cell][signfield][cell][b][field][/b]
[/table][hr]"}))

	// ------ Cargo (category 3) ------
	CatOf += 3
	T += list(list("name" = "Frontier Logistics Shipping Receipt", "content" = {"[center][h1][u]Frontier Logistics Receipt[/u][/h1][b][field][small](Time)[/small] on [field][small](Date)[/small][/b][/center][hr]
[b]Summary of Order:[/b] [field]
[b]Your Total:[/b] [field] credits
[b](Optional) Comments:[/b] [field][br]
[i][small]By signing this form as the undersigned 'Recipient', you affirm that all items listed on this form were present and functioning at the time of signing.[/small][/i][br]
[b]Recipient Signature:[/b] [signfield]
[b]Frontier Logistics Employee Signature:[/b] [signfield]
[i][small]Please stamp below to confirm.[/small][/i]"}))

	T += list(list("name" = "Lonestar Shipping Invoice", "content" = {"[center][h1][u]Lonestar Shipping LLC Sales Invoice[/u][/h1][b][field][small](Time)[/small] on [field][small](Date)[/small][/b]
[i][small][b]For Internal Use Only[/b][/small][/i][/center]
[hr]
[b]Summary of Purchase:[/b] [field][br]
[b]Standard Value of Purchase from Client (if applicable) (SV):[/b] [field] credits[br]
[b]Profit-Adjusted Value of Purchase from Client (PAV):[/b] [field] credits[br]
[hr]
[b](Optional) Maximum Allowed Profit Share for Purchasing Employee:[/b] [field] credits
[b](Optional) Employee's Share Taken:[/b] [field] credits[br]
[b]Lonestar Employee Signature: [/b][signfield]
[i][small]Please stamp below to confirm.[/small][/i]"}))
	CatOf += 3
	T += list(list("name" = "Frontier Logistics Sales Invoice", "content" = {"[center][h1][u]Frontier Logistics Sales Invoice[/u][/h1][b][field][small](Time)[/small] on [field][small](Date)[/small][/b][br][/center][hr]
[b]Summary of Sale:[/b] [field]
[b]Your Total:[/b] [field] credits
[b](Optional) Comments:[/b] [field][br]
[i][small]By signing this form as the undersigned 'Recipient', you affirm that all items listed on this form were present at the time of signing.[/small][/i][br]
[b]Recipient Signature:[/b] [signfield]
[b]Frontier Logistics Employee Signature:[/b] [signfield]
[i][small]Please stamp below to confirm.[/small][/i]"}))
	CatOf += 3
	T += list(list("name" = "Material Sale Form", "content" = {"[center][h1][u]Frontier Logistics Material Delivery Receipt[/u][/h1][b][field][small](Time)[/small] on [field][small](Date)[/small][/b][/center][hr]
[b]Shipment Destination:[/b] [field]
[b]Materials in this Order:[/b]
[list][*]Metal Sheet(s): [field]
[*]Plasteel Sheet(s): [field]
[*]Glass Sheet(s): [field]
[*]Reinforced Glass Sheet(s): [field]
[*]Gold Ingot(s): [field]
[*]Silver Ingot(s): [field]
[*]Other: [field][/list]
[b]Your Total:[/b] [field] credits
[b]Recipient Signature: [/b][signfield]
[b]Frontier Logistics Employee Signature: [/b][signfield]
[small][i]Please stamp below to confirm.[/i][/small]"}))

	// ------ Facility Director (category 4) ------
	CatOf += 4
	T += list(list("name" = "Transfer Form", "content" = {"[center][b][i]Transfer Request Form for[/b][/i]
Name: [field]
Rank: [field]
[i][b]Iskhod Outpost[/b][/i][/center][hr]
From department: [field]
To department: [field]
Requested Position: [field]
Reason(s): [field]
Sign here: [signfield]
[hr]
Signature of the faction head that is transferring the person: [signfield]
Signature of the faction head that is receiving the person: [signfield]
Signature of the Facility Director of the Iskhod Outpost: [signfield]
[hr]
Stamp below with the Facility Director stamp:"}))
	CatOf += 4
	T += list(list("name" = "Complaint Form", "content" = {"[b]OFFICE OF THE Facility Director[br]
Iskhod Outpost
STATEMENT OF COMPLAINT[/b]
[hr]
A. Professional Information - (Name of the person you are complaining about)
Full Name: [field]
Department: [field]
[hr]
B. Complainant (Your) Information
Full Name: [field]
Department: [field]
[hr]
C. Witnesses with factual knowledge of the events leading to your complaint, if applicable
First Witness: [field]
Second Witness, if any: [field]
[hr]
D. Description of complaint: Describe your complaint in detail below.
[field]
[hr]
E. Attach copies of related documents and records obtained during the course of the matter, if possible.[br]
[hr]
[b] Signature of Person Filing this Complaint[/b]: [signfield]"}))
	CatOf += 4
	T += list(list("name" = "Access Change Request", "content" = {"[b][u]ACCESS CHANGE REQUEST[/b][/u][hr]
[b]APPLICANT NAME:[/b] [field]
[b]APPLICANT CURRENT ASSIGNMENT:[/b] [field]
[b]REQUESTED ACCESS:[/b] [field]
[b]REASONING FOR ACCESS:[/b] [field]
[b]SIGNATURE OF APPLICANT:[/b] [signfield]
[b]SIGNATURE OF RELEVANT HEAD OF STAFF:[/b] [signfield]
[b]SIGNATURE OF Facility Director: [/b] [signfield]
[b]DATE AND TIME:[/b] [field]"}))

	// ------ Medical (category 5) ------
	CatOf += 5
	T += list(list("name" = "Medical Invoice", "content" = {"[center][large][b]Soteria Institute - Medical Department[/b][/large]
[i]Medical Services Invoice[/i]
[small][i]See Soteria Medical Policies for Pricing[/i][/small][/center][hr]
[b]Attending Physician:[/b] [field]
[b]Patient's Name:[/b] [field]
[hr]
[b]Treatment Rendered:[/b] - [field]
Elective Treatment? (Y/N) - [field]
Emergency Treatment? (Y/N) - [field]
[hr]
[b]Credit Total:[/b] [field] cr
Payment Notes: - [field]
[hr]
Attending Physician's Signature: [signfield]
Patient's or Payer's Signature: [signfield]
[hr][small]By signing this form, you confirm that all the above data is accurate.[/small][hr]"}))
	CatOf += 5
	T += list(list("name" = "Prescription Form", "content" = {"[center][large][b]Soteria Medical Department[/b][/large][/center]
[large][u]Prescription[/u]:[/large][br] [field][hr]
[u]For[/u]: [field] [br]
[u]Assignment[/u]: [field][hr]
[u]Prescribing Doctor[/u]: [field]
[u]Date[/u]: [field][hr]
[u]Medical Doctor[/u]: [field] [hr]
[small]This prescription will not be refilled except under written authorization.[/small]"}))
	CatOf += 5
	T += list(list("name" = "Autopsy Report", "content" = {"[center][h1]AUTOPSY REPORT[/h1][/center][hr]
[center][h3]IDENTIFICATION OF THE DECEASED[/h3][/center]
[b]Full Name:[/b] [field]
[b]Age:[/b] [field]
[b]Gender:[/b] [field]
[b]Species:[/b] [field]
[b]Faction:[/b] [field]
[b]Job:[/b] [field]
[hr]
[center][h3]INVESTIGATIVE FINDINGS:[/h3][/center]
[b]Date of Death:[/b] [date]
[b]Time of Death:[/b] [field]
[b]Approximate location of found body:[/b] [field]
[b]Cause of Death:[/b] [field]
[center][h3]Description of lesions[/h3][/center]
[b]Description of external wounds:[/b] [field]
[b]Description of internal wounds:[/b] [field]
[b]Trace chemicals found in body:[/b] [field][hr]
[b]Name:[/b] [field]
[b]Faction:[/b] [field]
[b]Rank:[/b] [field]
[b]Signature:[/b] [signfield][hr]"}))

	// ------ Security (category 6) ------
	CatOf += 6
	T += list(list("name" = "Crime Report", "content" = {"[large][b][center]Official Ranger Document[/b][/center][/large]
[i][center]ISKHOD OUTPOST[/i][/center]
[center][small]Crime Report[/small][/center][hr]
Suspect name: [field]
Crimes committed: [field]
Time of occurrence: [field]
Location(s) of occurrence: [field]
Persons involved: [field] [hr]
Details of Crime: [field]
Evidence of Crime: [field]
Arresting officer: [field]
Arresting officer Signature: [signfield]"}))
	CatOf += 6
	T += list(list("name" = "High Crime Report", "content" = {"[large][b][center]Official Security Document[/b][/center][/large]
[i][center]ISKHOD OUTPOST[/i][/center]
[center][small]High Crime Report[/small][/center][hr]
Suspect name: [field]
Crimes committed: [field]
Time of occurrence: [field]
Location(s) of occurrence: [field]
Persons involved: [field][hr]
Details of Crime: [field]
Evidence of Crime: [field][hr]
Arresting officer: [field]
Reviewing officer: [field]
Reviewer Comment: [field] [hr]
Arresting officer Signature: [signfield]
Reviewing officer Signature: [signfield]"}))
	CatOf += 6
	T += list(list("name" = "Arrest Warrant", "content" = {"[center][b][large] Arrest Warrant [/center][/b][/large][hr]
I, [field], with the rank [field] hereby declare that [field] is to be arrested for the following crimes, according to Outpost Law:[i] [field][/i][hr]
Their sentence is to be no less than [field] minutes, with the following modifiers (if applicable): [i][field][/i][hr]
They will be arrested by any security personnel that spots him/her and that is authorized and/or carrying this warrant.[br]
Signature of the Authorizing Individual: [signfield]
Stamp of the Warrant Officer (if applicable):[field][hr]"}))
	CatOf += 6
	T += list(list("name" = "Armoury Item Request", "content" = {"[center][Large][b]Armoury Item Request[/b][/large]
[small]For those armoury items that you need.[/small][/center][hr]
[b]Name:[/b] [field]
[b]Job:[/b] [field]
[b]Item(s):[/b] [field]
[b]Reason:[/b] [field][hr]
[b][center]Borrower's Signature:[/b] [u][i][signfield][/i][/u][/center][hr]
[center][small](Office to fill)[/small][/center]
[b]Approval Name:[/b] [field][hr]
[b][center]Approval's Signature:[/b] [u][i][signfield][/i][/u][/center][hr]"}))

	T += list(list("name" = "Armory Item Deployment Form", "content" = {"[center][b][u]Armory Item Deployment Form[/b][/u][/center][hr][small][i]The following item(s) are issued from the Armory to the recipient for use in accordance with standing security protocols.[/i][/small][hr][b]Item(s) issued: [/b][field][br]
[b]Issued by: [/b][field]
[b]Reason: [/b][field]
[b]Recipient's Name: [/b][field]
[b]Rank: [/b][field]
[small][i]This form must be signed by the Recipient and the Supply Specialist![/i][/small]
[hr][b]Recipient's Signature: [/b][signfield]
[b]Supply Specialist Signature: [/b][signfield][hr]"}))
	CatOf += 6
	T += list(list("name" = "Criminal Prosecution Form", "content" = {"[center][b][u]Criminal Prosecution Form[/b][/u][/center][small][i]This form records the event and circumstances of the criminal prosecution of this colonist.[/i][/small][hr]
[b]Offender's name: [/b][field]
[b]Offender's title: [/b][field]
[b]Crime(s) committed: [/b][field][br][hr]
[b]Witness(es): [/b][field]
[b]Interrogation conducted by: [/b][field]
[i]Transcript attached?(yes/no): [/i][field][br]
[b]Item(s) taken into evidence: [/b][field][br][hr]
[b][u]Sentence: [/u][/b][field]
[i]Modifying factors: [/i][field]
[b]Sentence interval (if applicable): [/b][field]
[b]Sentenced by: [/b][field]
[b]Signature: [/b][signfield][hr]"}))

	T += list(list("name" = "Search Warrant", "content" = {"[center][b][u]Search Warrant[/b][/u][/center][small][i]The Security Officer(s) bearing this Warrant are hereby authorized to conduct a one time lawful search.[/i][/small][hr]
[b]Suspect's Name*: [/b][field]
[b]Suspect's Title*: [/b][field]
[b]Department: [/b][field]
[b]Suspected Crime(s): [/b][field]
[b]Extent of search: [/b][field]
[b]Warrant issued by: [/b][field]
[b]Signature: [/b][signfield][hr]
[b]Search conducted by: [/b][field]
[b]Item(s) taken as evidence: [/b][field]
[b]Notes: [/b][field]
[b]Signature: [/b][signfield][hr]"}))
	CatOf += 6
	T += list(list("name" = "Interrogation Report", "content" = {"[center][b][u]Interrogation Report[/b][/u][/center][small][i]An audio recording or transcript of the interview must be attached to this report to be considered valid![/i][/small][hr][b]Interviewer's name: [/b][field]
[b]Rank: [/b][field]
[b]Interviewee's name: [/b][field]
[b]Title: [/b][field]
[b]Designation (Suspect/Witness/Other): [/b][field]
[b]Interviewee's Legal Aid present: [/b][field]
[b]Other personnel present: [/b][field][hr][b][u]Interview Notes: [/u][/b][field][hr][b]Interviewer's Signature: [/b][signfield][hr]"}))
	CatOf += 6
	T += list(list("name" = "Evidence Log", "content" = {"[b][center][u][large]Evidence/Contraband Inventory Log[/large][/b][/center][/u][hr]
[b]Time:[/b][field]
[b]Log Number:[/b][field]
[b]Listed Confiscations:[/b]
* [field]
* [field]
* [field]
* [field]
* [field]
* [field]
* [field][hr][b]Confiscating officers signature: [signfield][/b][hr]"}))
	CatOf += 6
	T += list(list("name" = "Injunction Report", "content" = {"[center][large][b]ISKHOD OUTPOST[/b][/large][/center]
[center][b]Official Ranger Document[/b][/center]
[center][small]Injunction Report[/small][/center][hr]
[b]Date: [/b][date]
[b]Time: [/b][time]
[b]Reporting Officer:[/b] [field]
[b]Rank:[/b] [field][hr]
[b]Subject of Injunction:[/b] [field]
[b]Subject's Position/Department:[/b] [field][hr]
[b]Nature of Injunction:[/b]
[field][hr]
[b]Conditions / Required Compliance:[/b]
[field][hr]
[b]Time frame for compliance:[/b] [field]
[b]Consequences of non-compliance:[/b] [field][hr]
[b]Authorized by:[/b] [field]
[b]Signature:[/b] [signfield]
[b]Stamp of Warrant Officer (if applicable):[/b][field][hr]"}))

	// ------ R&D (category 7) ------
	CatOf += 7
	T += list(list("name" = "R&D Equipment Loan Form", "content" = {"[b]Equipment Loan[/b]
[hr]
The following item(s) are considered experimental. The receiver must use the following item(s) only for their intended purpose.
[hr]
Item(s) loaned:[field]
Name of receiver: [field]
Name of colony member loaning the item(s): [field]
Note: Please make sure this form is stamped below the line by related head of staff before the end of one standard work week. [hr]"}))
	CatOf += 7
	T += list(list("name" = "R&D Testing Waiver", "content" = {"[b]Testing Liability Waiver[/b][hr]
The following persons have consented to testing with the Soteria research division. Neither the colony nor the Soteria Institute can be held responsible for injury sustained during the duration of testing.
[hr]
Name of volunteer test subject: [field]
Research Experiment and Goal(s): [field][hr]
Signature of Volunteer Test Subject: [signfield]
Signature of Soteria Staff: [signfield][hr]"}))

	// ------ Prospector & Blackshield (category 8) ------
	CatOf += 8
	T += list(list("name" = "Blackshield Escort Request", "content" = {"[center][h1]Iskhod Outpost[/h1][large]Blackshield Escort Request[/large][/center] [hr] [small][center][i]The following form indicates that the Blackshield Regiment will escort the Prospectors for the duration of their journey.[/center][/i][/small] [hr] [u]General Information:[/u]
Date: [field]
Time of Departure: [field]
Location: [field]
Estimated Threats:[list][*][field][*][field][*][field][/list][u]Requester Information:[/u]
Name(s): [field]
Position(s): [field]
Required Credits: [field]
[u]Blackshield Escorts:[/u]
Name: [field] Position: [field]
Name: [field] Position: [field]
[hr] Authorizing Party Signature: [signfield]
Requester(s) Signature(s): [signfield] [hr]"}))
	CatOf += 8
	T += list(list("name" = "Mission Report", "content" = {"[b][large]Iskhod Outpost[/large][/b]
[i]Mission Report[/i][hr][b]Involved person(s)[/b]: [field]
[b]Mission event(s) description[/b]: [field]
[b]Other Details(s)[/b]: [field][hr][small][signfield]; Rank: [field]
This document is void unless stamped.[/small]"}))
	CatOf += 8
	T += list(list("name" = "Blackshield Cadetship Application", "content" = {"[center][h1]Iskhod Outpost[/h1][h3]Blackshield Regiment[/h3][large]Cadetship Application[/center][hr]
[b]Blackshield Regiment (SURFACE) Cadetship Application[/b]
DTG: [date], [time]
Index: [field]
[b]General Information[/b]
Full Name: [field]
Position: [field]
Faction: [field]
Prior Firearms Training (Y/N): [field]
Prior Military Experience (Y/N): [field]
Prior Police Experience (Y/N):[field]
[hr][b]Personal Information[/b]
Species: [field]
Age: [field]
Date of Birth: [field]
Place of Birth: [field]
What made you want to join the Blackshield Regiment? [field]
Applicant's Signature: [signfield]
[hr]
Blackshield Commander's Signature: [signfield]
Blackshield Sergeant's Signature (If Applicable): [signfield][hr]"}))
	CatOf += 8
	T += list(list("name" = "Gate Log", "content" = {"[h3][center][u]Gate Log[/h3][/center][/u][hr][b]Logging Staff:[/b][field]
[b]Gate Log Number:[/b][field][hr]
[table][row][cell]Name[cell]Rank[cell]Departure time[cell]Return time[cell]Destination[cell]Notes
[row][cell][field][cell][field][cell][field][cell][field][cell][field][cell][field]
[row][cell][field][cell][field][cell][field][cell][field][cell][field][cell][field]
[row][cell][field][cell][field][cell][field][cell][field][cell][field][cell][field]
[/table][b]Always note the name, rank, destination, and time that person entered and exited.[/b]"}))

	// ------ Hunters Lodge (category 9) ------
	CatOf += 9
	T += list(list("name" = "Hunting Lodge Check-In", "content" = {"[center]
[large][b]Hunter's Lodge Team Check-in. [date]
[/b][/large][/center]
[hr]
[small][i]Fill in your name in an available slot based on your role and sign.[/i][/small]
[u]Lodge Hunt Master:[/u] [field]
[u]Lodge Hunter 1:[/u] [field]
[u]Lodge Hunter 2:[/u] [field]
[u]Lodge Hunter 3:[/u] [field]
[u]Lodge Hunter 4:[/u] [field]
[hr]
[u]Lodge Herbalist 1:[/u] [field]
[u]Lodge Herbalist 2:[/u] [field]
[hr]
[large][b][u]And remember good hunting.[/u][/b][/large]"}))

	// Build category list for UI: list( list("name" = "Generic", "forms" = list( list("name" = "...", "cat_index" = 1, "form_index" = 1), ... ) ), ... )
	var/list/cat_names = list("Generic", "Heads of Department", "Cargo", "Facility Director", "Medical", "Security", "R&D", "Prospector & Blackshield", "Hunters Lodge")
	var/list/cat_forms = list(list(), list(), list(), list(), list(), list(), list(), list(), list())
	for(var/i = 1, i <= length(T), i++)
		var/cat_id = CatOf[i]
		if(cat_id >= 1 && cat_id <= length(cat_forms))
			var/list/entry = T[i]
			var/form_idx = length(cat_forms[cat_id]) + 1
			cat_forms[cat_id] += list(list("name" = entry["name"], "cat_index" = cat_id, "form_index" = form_idx, "flat_index" = i))
	for(var/cat_id = 1, cat_id <= length(cat_names), cat_id++)
		if(length(cat_forms[cat_id]))
			req_console_paperwork_categories += list(list("name" = cat_names[cat_id], "forms" = cat_forms[cat_id]))
	return

/proc/get_paperwork_form_by_category(cat_index, form_index)
	if(!length(req_console_paperwork_templates)) init_req_console_paperwork()
	var/list/cat = (cat_index >= 1 && cat_index <= length(req_console_paperwork_categories)) ? req_console_paperwork_categories[cat_index] : null
	if(!cat || !cat["forms"]) return null
	var/list/forms = cat["forms"]
	if(form_index < 1 || form_index > length(forms)) return null
	var/list/fe = forms[form_index]
	var/flat = fe["flat_index"]
	if(flat >= 1 && flat <= length(req_console_paperwork_templates))
		return req_console_paperwork_templates[flat]
	return null

/proc/req_console_paperwork_to_pencode(template_text)
	// Convert wiki-style [tag] to game pencode \[tag\] so [field] becomes writable and formatting works.
	if(!template_text) return ""
	var/t = template_text
	// Closing tags first (plain tags as stored in template)
	t = replacetext(t, "[/table]", "\\[/table\\]")
	t = replacetext(t, "[/list]", "\\[/list\\]")
	t = replacetext(t, "[/large]", "\\[/large\\]")
	t = replacetext(t, "[/center]", "\\[/center\\]")
	t = replacetext(t, "[/h3]", "\\[/h3\\]")
	t = replacetext(t, "[/h2]", "\\[/h2\\]")
	t = replacetext(t, "[/h1]", "\\[/h1\\]")
	t = replacetext(t, "[/small]", "\\[/small\\]")
	t = replacetext(t, "[/b]", "\\[/b\\]")
	t = replacetext(t, "[/i]", "\\[/i\\]")
	t = replacetext(t, "[/u]", "\\[/u\\]")
	// Opening tags and primitives
	t = replacetext(t, "[table]", "\\[table\\]")
	t = replacetext(t, "[list]", "\\[list\\]")
	t = replacetext(t, "[large]", "\\[large\\]")
	t = replacetext(t, "[center]", "\\[center\\]")
	t = replacetext(t, "[h3]", "\\[h3\\]")
	t = replacetext(t, "[h2]", "\\[h2\\]")
	t = replacetext(t, "[h1]", "\\[h1\\]")
	t = replacetext(t, "[small]", "\\[small\\]")
	t = replacetext(t, "[b]", "\\[b\\]")
	t = replacetext(t, "[i]", "\\[i\\]")
	t = replacetext(t, "[u]", "\\[u\\]")
	t = replacetext(t, "[field]", "\\[field\\]")
	t = replacetext(t, "[signfield]", "\\[signfield\\]")
	t = replacetext(t, "[date]", "\\[date\\]")
	t = replacetext(t, "[time]", "\\[time\\]")
	t = replacetext(t, "[br]", "\\[br\\]")
	t = replacetext(t, "[hr]", "\\[hr\\]")
	t = replacetext(t, "[*]", "\\[*\\]")
	t = replacetext(t, "[row]", "\\[row\\]")
	t = replacetext(t, "[cell]", "\\[cell\\]")
	t = replacetext(t, "[logo]", "\\[logo\\]")
	return t
