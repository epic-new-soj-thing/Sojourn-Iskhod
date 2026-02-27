/obj/item/device/eftpos/medical
	name = "medical EFTPOS scanner"
	desc = "A specialized EFTPOS scanner for medical services. Accounts for insurance coverage."
	icon_state = "eftpos"
	eftpos_name = "Medical EFTPOS scanner"
	var/patient_name = "Unknown"
	var/physician_name = "Unknown"
	var/list/treatments = list() // Generic text list of treatments
	var/is_elective = FALSE
	var/is_emergency = FALSE
	var/is_work_related = FALSE
	var/signed_physician = FALSE
	var/signed_patient = FALSE
	var/datum/money_account/patient_account
	var/subtotal = 0
	var/total_bill = 0
	var/insurance_coverage = 0
	var/list/medical_item_categories = list(
		"Facility Usage" = list("Sleeper Usage", "Cryopod Usage"),
		"Medical Supplies" = list("Unbranded Gauze/Ointment", "Advanced Gauze/Ointment", "Branded Gauze/Ointment"),
		"Standard Care" = list("Blood Transfusion", "Chemicals and Medication", "Defibrillation", "Surgery"),
		"Advanced Procedures" = list("Organ Biomodification", "New Tissues/Organs", "Custom Organelles"),
		"Prosthesis" = list("Basic Prosthetic", "Standard Prosthetic", "Advanced Prosthetic", "Kyphotorin Regeneration"),
		"Robotic Organs & Implants" = list("Organ Cybermodification", "Standard Robotic Organ", "Advanced Robotic Organ", "Internal Implant")
	)
	var/medical_item_costs = list(
		// Facility Usage
		"Sleeper Usage" = 40,
		"Cryopod Usage" = 60,
		// Medical Supplies
		"Unbranded Gauze/Ointment" = 5,
		"Advanced Gauze/Ointment" = 10,
		"Branded Gauze/Ointment" = 25,
		// Standard Care
		"Blood Transfusion" = 25,
		"Chemicals and Medication" = 30,
		"Defibrillation" = 75,
		"Surgery" = 80,
		// Advanced Procedures
		"Organ Biomodification" = 75,
		"New Tissues/Organs" = 150,
		"Custom Organelles" = 250,
		// Prosthesis
		"Basic Prosthetic" = 500,
		"Standard Prosthetic" = 1000,
		"Advanced Prosthetic" = 1500,
		"Kyphotorin Regeneration" = 2000,
		// Robotic Organs & Implants
		"Organ Cybermodification" = 300,
		"Standard Robotic Organ" = 600,
		"Advanced Robotic Organ" = 1200,
		"Internal Implant" = 450
	)

/obj/item/device/eftpos/medical/New()
	..()
	initialize_linked_account()

/obj/item/device/eftpos/medical/Initialize()
	..()
	initialize_linked_account()

/obj/item/device/eftpos/medical/initialize_linked_account()
	// Connect to medical account by default if possible
	if(!economy_init)
		addtimer(CALLBACK(src, PROC_REF(initialize_linked_account)), 5 SECONDS)
		return

	for(var/i in department_accounts)
		var/datum/money_account/A = department_accounts[i]
		if(A.department_id == DEPARTMENT_MEDICAL)
			linked_account = A
			break

/obj/item/device/eftpos/medical/spawn_startup_items()
	..()
	print_price_list()

/obj/item/device/eftpos/medical/create_manual()
	var/obj/item/paper/R = new(src.loc)
	R.name = "Medical Services Billing Guide"
	R.info += "<b>Vesalius-Andra Medical Billing System Guide</b><hr>"
	R.info += "1. Scan the patient's ID card to retrieve their account and insurance details.<br>"
	R.info += "2. Select the services rendered from the treatment categories. Prices are set by Soteria policy.<br>"
	R.info += "3. The system will automatically calculate subtotal and insurance coverage based on employment and service type.<br>"
	R.info += "4. Toggle elective, emergency, or work-related flags as appropriate for maximum billing accuracy.<br>"
	R.info += "5. Lock the transaction once all services are entered.<br>"
	R.info += "6. Ask the patient (or responsible party) to swipe their ID and enter their PIN to finalize payment.<br>"
	R.info += "7. Ensure both physician and patient sign the final receipt for audit compliance.<br>"

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	R.add_overlay(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by the Medical EFTPOS.</i>"
	R.stamped &= STAMP_DOCUMENT
	return R

/obj/item/device/eftpos/medical/proc/print_price_list()
	var/obj/item/paper/P = new(loc)
	P.name = "Medical Service Price List"
	var/dat = "<b>[eftpos_name] - Service Pricing</b><br><hr>"
	for(var/cat in medical_item_categories)
		dat += "<i><b>[cat]</b></i><br>"
		for(var/t in medical_item_categories[cat])
			dat += "&nbsp;&nbsp;[t]: [medical_item_costs[t]]cr<br>"
		dat += "<br>"
	P.info = dat
	P.update_icon()
	return P

/obj/item/device/eftpos/medical/attack_self(mob/user as mob)
	if(get_dist(src,user) <= 1)
		if(!linked_account)
			initialize_linked_account()

		var/dat = "<b>[eftpos_name]</b><br>"
		dat += "<i>Physician:</i> <a href='?src=\ref[src];choice=set_physician'>[physician_name]</a> <a href='?src=\ref[src];choice=sign_physician'>([signed_physician ? "Signed" : "Sign"])</a><br>"
		dat += "<i>Patient:</i> [patient_account ? patient_account.owner_name : "Scan ID"] <a href='?src=\ref[src];choice=clear_patient'>(Clear)</a> <a href='?src=\ref[src];choice=sign_patient'>([signed_patient ? "Signed" : "Sign"])</a><br><hr>"

		dat += "<b>Treatment Selection:</b><br>"
		for(var/cat in medical_item_categories)
			dat += "<i>[cat]</i><br>"
			for(var/t in medical_item_categories[cat])
				var/amount = treatments[t] || 0
				dat += "&nbsp;&nbsp;[t] ([medical_item_costs[t]]cr): <a href='?src=\ref[src];choice=sub_treatment;type=[t]'>-</a> <a href='?src=\ref[src];choice=set_treatment;type=[t]'>[amount]</a> <a href='?src=\ref[src];choice=add_treatment;type=[t]'>+</a><br>"

		dat += "<hr>"
		dat += "<b>Options:</b><br>"
		dat += "Elective Procedure: <a href='?src=\ref[src];choice=toggle_elective'>[is_elective ? "YES" : "NO"]</a><br>"
		dat += "Emergency Procedure: <a href='?src=\ref[src];choice=toggle_emergency'>[is_emergency ? "YES" : "NO"]</a><br>"
		dat += "Work Related: <a href='?src=\ref[src];choice=toggle_work'>[is_work_related ? "YES" : "NO"]</a><br>"

		dat += "<hr>"
		calculate_bill()
		dat += "Subtotal: [subtotal]cr<br>"
		dat += "Insurance Coverage: [insurance_coverage]cr<br>"
		dat += "<b>FINAL TOTAL: [total_bill]cr</b><br>"

		if(patient_account)
			if(!transaction_locked)
				dat += "<a href='?src=\ref[src];choice=toggle_lock'>Lock and Bill</a><br>"
			else
				if(transaction_paid)
					dat += "<i>PAID</i> - <a href='?src=\ref[src];choice=print_receipt'>Print Receipt</a><br>"
					dat += "<a href='?src=\ref[src];choice=toggle_lock'>Reset</a>"
				else
					dat += "<b>Awaiting Payment...</b> <a href='?src=\ref[src];choice=toggle_lock'>Cancel</a>"
		else
			dat += "<i>Scan patient ID to proceed</i>"

		user << browse(HTML_SKELETON(dat),"window=eftpos_med")
	else
		user << browse(null,"window=eftpos_med")

/obj/item/device/eftpos/medical/proc/calculate_bill()
	subtotal = 0
	insurance_coverage = 0

	if(!patient_account)
		for(var/t in treatments)
			subtotal += medical_item_costs[t] * treatments[t]
		total_bill = subtotal
		return

	var/datum/department/D = GLOB.all_departments[patient_account.employer]
	var/limit = D ? D.insurance_limit : 500
	var/spent = patient_account.insurance_spent
	var/available = max(0, limit - spent)

	var/list/high_costs = list("Basic Prosthetic", "Standard Prosthetic", "Advanced Prosthetic", "Kyphotorin Regeneration", "New Tissues/Organs", "Custom Organelles", "Standard Robotic Organ", "Advanced Robotic Organ", "Internal Implant")

	// Check if they are a head of staff for better coverage
	var/head_bonus = 0
	var/datum/computer_file/report/crew_record/R = get_crewmember_record(patient_account.owner_name)
	if(R && (R.get_job() in list("Facility Director", "Medical Overseer", "Chief Engineer", "Captain", "Lieutenant", "Steward", "Research Overseer")))
		head_bonus = 0.2 // 20% more coverage for heads

	for(var/t in treatments)
		var/item_cost = medical_item_costs[t] * treatments[t]
		subtotal += item_cost

		if(is_work_related || patient_account.employer == DEPARTMENT_MEDICAL)
			var/work_pct = D ? D.work_coverage : 0
			var/covered = round(item_cost * work_pct)
			insurance_coverage += covered
			continue

		var/coverage_pct = 1.0 // Standard is 100% up to limit

		if(is_elective || (t in high_costs))
			// Electives and high-cost items get a flat percentage reduction
			// These are "billed at full price with a percent reduction" and do not use the shift limit.
			coverage_pct = (D ? D.elective_reduction : 0.5) + head_bonus
			coverage_pct = min(1.0, max(0, coverage_pct))
			insurance_coverage += round(item_cost * coverage_pct)
		else
			// Non-electives are 100% covered up to the shift limit
			var/covered = min(item_cost, available)
			insurance_coverage += covered
			available -= covered

	total_bill = subtotal - insurance_coverage

/obj/item/device/eftpos/medical/Topic(href, href_list)
	if(..()) return 1

	switch(href_list["choice"])
		if("set_physician")
			var/new_name = sanitize(input("Enter physician name", "Medical EFTPOS", physician_name), MAX_NAME_LEN)
			if(new_name) physician_name = new_name
		if("clear_patient")
			patient_account = null
			patient_name = "Unknown"
			signed_patient = FALSE
		if("sign_physician")
			signed_physician = !signed_physician
		if("sign_patient")
			signed_patient = !signed_patient
		if("add_treatment")
			var/t = href_list["type"]
			treatments[t] += 1
		if("sub_treatment")
			var/t = href_list["type"]
			if(treatments[t])
				treatments[t] -= 1
				if(treatments[t] <= 0)
					treatments.Remove(t)
		if("set_treatment")
			var/t = href_list["type"]
			var/new_amount = input("Enter amount for [t]", "Medical EFTPOS", treatments[t] || 0) as num
			if(new_amount >= 0)
				treatments[t] = round(new_amount)
				if(treatments[t] <= 0)
					treatments.Remove(t)
		if("toggle_elective")
			is_elective = !is_elective
			if(is_elective) is_emergency = FALSE
		if("toggle_emergency")
			is_emergency = !is_emergency
			if(is_emergency) is_elective = FALSE
		if("toggle_work")
			is_work_related = !is_work_related
		if("print_receipt")
			if(transaction_paid)
				print_medical_receipt()

	attack_self(usr)

/obj/item/device/eftpos/medical/scan_card(var/obj/item/card/I, var/obj/item/ID_container)
	if (istype(I, /obj/item/card/id))
		var/obj/item/card/id/C = I
		if(!patient_account)
			patient_account = get_account(C.associated_account_number)
			patient_name = C.registered_name
			to_chat(usr, SPAN_NOTICE("Patient identified: [patient_name]"))
			attack_self(usr)
			return

		if(transaction_locked && !transaction_paid)

			// Payment logic
			if(total_bill > 0)
				var/datum/money_account/pay_acc = get_account(C.associated_account_number)
				if(pay_acc && pay_acc.money >= total_bill)
					if(pay_acc.security_level)
						var/attempt_pin = input("Enter pin code", "Medical EFTPOS transaction") as num
						if(attempt_pin != pay_acc.remote_access_pin)
							to_chat(usr, SPAN_WARNING("Invalid PIN."))
							return

					pay_acc.money -= total_bill
					var/datum/transaction/T = new(-total_bill, "[linked_account.owner_name] (Medical)", "Medical Services", machine_id)
					pay_acc.transaction_log.Add(T)

					if(linked_account)
						var/datum/transaction/T2 = new(total_bill, pay_acc.owner_name, "Medical Services", machine_id)
						linked_account.money += total_bill
						linked_account.transaction_log.Add(T2)

					transaction_paid = TRUE
					signed_patient = TRUE
					playsound(src, 'sound/machines/chime.ogg', 50, 1)

					// Apply insurance usage
					if(insurance_coverage > 0 && !is_elective && patient_account)
						patient_account.insurance_spent += insurance_coverage
						// Maybe charge the department account?
						var/datum/money_account/dept_acc = department_accounts[patient_account.employer]
						if(dept_acc)
							dept_acc.money -= insurance_coverage
							var/datum/transaction/T3 = new(-insurance_coverage, "[linked_account.owner_name] (Medical)", "Insurance Coverage - [patient_account.owner_name]", machine_id)
							dept_acc.transaction_log.Add(T3)

					// Auto-reset
					print_medical_receipt()
					transaction_locked = 0
					transaction_paid = 0
					treatments.Cut()
					is_elective = FALSE
					is_emergency = FALSE
					is_work_related = FALSE
					signed_physician = FALSE
					signed_patient = FALSE
					patient_account = null
					patient_name = "Unknown"
				else
					to_chat(usr, SPAN_WARNING("Insufficient funds."))
			else
				// Total bill is 0 (fully covered)
				transaction_paid = TRUE
				signed_patient = TRUE
				playsound(src, 'sound/machines/chime.ogg', 50, 1)
				if(insurance_coverage > 0 && patient_account)
					patient_account.insurance_spent += insurance_coverage
					var/datum/money_account/dept_acc = department_accounts[patient_account.employer]
					if(dept_acc)
						dept_acc.money -= insurance_coverage
						var/datum/transaction/T3 = new(-insurance_coverage, "[linked_account.owner_name] (Medical)", "Insurance Coverage - [patient_account.owner_name]", machine_id)
						dept_acc.transaction_log.Add(T3)

				// Auto-reset
				print_medical_receipt()
				transaction_locked = 0
				transaction_paid = 0
				treatments.Cut()
				is_elective = FALSE
				is_emergency = FALSE
				is_work_related = FALSE
				signed_physician = FALSE
				signed_patient = FALSE
				patient_account = null
				patient_name = "Unknown"

	attack_self(usr)

/obj/item/device/eftpos/medical/proc/print_medical_receipt()
	var/turf/printing_loc = get_turf(src)
	var/treatment_text = ""
	for(var/t in treatments)
		treatment_text += " - [t] x[treatments[t]]<br>"

	var/receipt_content = {"
<center><large><b>Vesalius-Andra - Medical Department</b></large>
<i>Medical Services Invoice</i>
<small><i>See Soteria Medical Policies for Pricing</i></small></center><hr>
<b>Attending Physician:</b> [physician_name]<br>
<b>Patient's Name:</b> [patient_name]<br>

<hr>
<b>Treatment Rendered:</b><br>
[treatment_text]

Elective Treatment? (Y/N)
 - [is_elective ? "YES" : "NO"]<br>
Emergency Treatment? (Y/N)
 - [is_emergency ? "YES" : "NO"]<br>

<hr>
<b>Credit Total:</b> [total_bill] cr<br>
<b>Insurance Covered:</b> [insurance_coverage] cr<br>
Payment Notes:<br>
 - [is_work_related ? "Work-Related Injury Coverage Applied" : "Standard Insurance Coverage Applied"]<br>

<hr>
<b>Attending Physician's Signature:</b> [signed_physician ? physician_name : "________________"]<br>
<b>Patient's or Payer's Signature:</b> [signed_patient ? patient_name : "________________"]<br>

<hr><small>By signing this form, you confirm that all the above data is accurate to the best of your knowledge and ability, and waive the Soteria Institute of any liability for incorrect charges.</small><hr>
"}

	var/obj/item/paper/carbon/P = new /obj/item/paper/carbon(printing_loc, receipt_content, "Medical Receipt - [patient_name]")
	P.update_icon()
	to_chat(usr, SPAN_NOTICE("Receipt printed."))

/obj/item/device/eftpos/medical/roboticist
	name = "roboticist EFTPOS scanner"
	desc = "A specialized EFTPOS scanner for biomechanical services. Accounts for insurance coverage."
	icon_state = "eftpos"
	eftpos_name = "Roboticist EFTPOS scanner"
	medical_item_categories = list(
		"Standard Care" = list("Chemicals and Medication", "Surgery"),
		"Prosthesis" = list("Basic Prosthetic", "Standard Prosthetic", "Advanced Prosthetic"),
		"Robotic Organs & Implants" = list("Organ Cybermodification", "Standard Robotic Organ", "Advanced Robotic Organ", "Internal Implant")
	)
	medical_item_costs = list(
		// Standard Care
		"Chemicals and Medication" = 30,
		"Surgery" = 80,
		// Prosthesis
		"Basic Prosthetic" = 500,
		"Standard Prosthetic" = 1000,
		"Advanced Prosthetic" = 1500,
		// Robotic Organs & Implants
		"Organ Cybermodification" = 300,
		"Standard Robotic Organ" = 600,
		"Advanced Robotic Organ" = 1200,
		"Internal Implant" = 450
	)

/obj/item/device/eftpos/medical/roboticist/New()
	..()
	initialize_linked_account()

/obj/item/device/eftpos/medical/roboticist/Initialize()
	..()
	initialize_linked_account()

/obj/item/device/eftpos/medical/roboticist/initialize_linked_account()
	// Connect to science account by default if possible
	if(!economy_init)
		addtimer(CALLBACK(src, PROC_REF(initialize_linked_account)), 5 SECONDS)
		return

	for(var/i in department_accounts)
		var/datum/money_account/A = department_accounts[i]
		if(A.department_id == DEPARTMENT_SCIENCE)
			linked_account = A
			break

/obj/item/device/eftpos/medical/roboticist/create_manual()
	var/obj/item/paper/R = new(src.loc)
	R.name = "Biomechanical Services Fee Guide"
	R.info += "<b>Vesalius-Andra Biomechanics Branch Service Guide</b><hr>"
	R.info += "1. Scan patient ID to link their personal account.<br>"
	R.info += "2. Itemize all implants, prosthetics, and surgical procedures performed.<br>"
	R.info += "3. The scanner is pre-configured to link with VA Biomechanics (Research Division) department account.<br>"
	R.info += "4. Finalize the bill and have the recipient authorize the transaction via PIN.<br>"
	R.info += "5. Use the receipt for internal reporting to the Research Overseer.<br>"

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	R.add_overlay(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by the Biomechanical EFTPOS.</i>"
	R.stamped &= STAMP_DOCUMENT
	return R

/obj/item/device/eftpos/medical/roboticist/print_medical_receipt()
	var/turf/printing_loc = get_turf(src)
	var/treatment_text = ""
	for(var/t in treatments)
		treatment_text += " - [t] x[treatments[t]]<br>"

	var/receipt_content = {"
<center><large><b>Vesalius-Andra - Biomechanics Branch</b></large>
<i>Biomechanical Services Invoice</i>
<small><i>See VA Biomechanics Policies for Pricing</i></small></center><hr>
<b>Attending Roboticist:</b> [physician_name]<br>
<b>Patient's Name:</b> [patient_name]<br>

<hr>
<b>Services Rendered:</b><br>
[treatment_text]

<hr>
<b>Credit Total:</b> [total_bill] cr<br>
<b>Insurance Covered:</b> [insurance_coverage] cr<br>
Payment Notes:<br>
 - [is_work_related ? "Work-Related Injury Coverage Applied" : "Standard Insurance Coverage Applied"]<br>

<hr>
<b>Attending Roboticist's Signature:</b> [signed_physician ? physician_name : "________________"]<br>
<b>Patient's or Payer's Signature:</b> [signed_patient ? patient_name : "________________"]<br>

<hr><small>By signing this form, you confirm that all the above data is accurate to the best of your knowledge and ability, and waive VA Biomechanics of any liability for incorrect charges.</small><hr>
"}

	var/obj/item/paper/carbon/P = new /obj/item/paper/carbon(printing_loc, receipt_content, "Maintenance Receipt - [patient_name]")
	P.update_icon()
	to_chat(usr, SPAN_NOTICE("Receipt printed."))
