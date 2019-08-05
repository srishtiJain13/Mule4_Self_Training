%dw 2.0
output application/xml
ns stl18 http://webservices.sabre.com/pnrbuilder/v1_18
ns ns6 http://www.opentravel.org/OTA/2003/05/beta
ns raw http://tds.sabre.com/itinerary
ns ns4 http://webservices.sabre.com/pnrconn/ReaccSearch
ns or112 http://services.sabre.com/res/or/v1_12
ns ns0 http://schemas.xmlsoap.org/soap/envelope/

var jsonReq=vars.originalReq.request

fun getPassenger
(nameId) =  payload.GetReservationRS.Reservation.PassengerReservation.Passengers.*Passenger filter ((i,j) -> (i.@nameId == nameId))
fun getPassengerNS
(nameId) =  payload.stl18#GetReservationRS.stl18#Reservation.stl18#PassengerReservation.stl18#Passengers.*stl18#Passenger filter ((i,j) -> (i.@nameId == nameId)) 
 
fun getPassengerReferenceNumNS (nameId) = getPassengerNS(nameId).@referenceNumber[0]

fun getAncillaryService (id) = getAncillaryServiceNS(id)

fun getAncillaryServiceNS
(id)= payload.stl18#GetReservationRS.stl18#Reservation.stl18#PassengerReservation.stl18#Passengers.*stl18#Passenger.stl18#AncillaryServices.stl18#AncillaryService filter ((i,j) -> (i.@id == id))
---
{
	ns0#Envelope: {
		ns0#Body: {
	ns6#PaymentRQ @(
		"SystemDateTime":jsonReq.pos.localDateTime,
		"Version":"3.0.0"
	): {
		ns6#Action:"OrchPayment", 
		ns6#POS 
		@("PseudoCityCode": payload.GetReservationRS.Reservation.POS.Source.@PseudoCityCode,
			"AgentSine": jsonReq.pos.sine,
			"LNIATA": jsonReq.pos.lniata,
			"StationNumber": jsonReq.pos.aaa.number,
			"ISOCountry": jsonReq.pos.aaa.country,
			"ChannelID": jsonReq.pos.channel,
			"LocalDateTime": jsonReq.pos.localDateTime,
			"SourceID": jsonReq.pos.source
		):{},
		ns6#MerchantDetail @("MerchantID": jsonReq.pos.company):{},
		ns6#OrderDetail @("RecordLocator": jsonReq.pnr) : {
			(jsonReq.orderDetails.passengerDetails map (item,index) -> {
				ns6#PassengerDetail @(
					"NameNumberInPNR": item.nameNumber,
					"PsgrType": getPassenger(item.nameNumber).@referenceNumber[0]): {
						(jsonReq.ticketingData.emd.emdDocuments map (emdDocuments, docIndex) -> {
							(ns6#Document @("DocType":"EMD",
										"DocCurrency": getPassenger(item.nameNumber).AncillaryServices.AncillaryService.TotalTTLPrice.Currency[0],
										"DocAmount":getPassenger(item.nameNumber).AncillaryServices.AncillaryService.TotalTTLPrice.Price[0],
										"AssociatedDocNumber":emdDocuments.documentAssociation[0].ticketNumber
						):{}
						) if (getPassenger(item.nameNumber).AncillaryServices.AncillaryService.@id[0] == emdDocuments.aeItemId) })
				}
		})},
		ns6#PaymentDetail: jsonReq.paymentData.payments map ((item, index) -> {
			ns6#FOP @("Type":"CC", "FOP_Code":item.cardCode):{},
			ns6#PaymentCard @(
				"CardCode":item.cardCode,
				"CardNumber":item.cardNumber,
				"CardSecurityCode":item.cardSecurityCode,
				"ExpireDate":item.expirationDate):{
					ns6#CardHolderName @(
						"FirstName":item.cardHolder.firstName,
						"LastName":item.cardHolder.lastName
					):{}
				},
				ns6#AmountDetail @(
					"Amount":item.details.amount.value,
					"CurrencyCode":item.details.amount.currency
				):{}
		})
	}
}
}
}