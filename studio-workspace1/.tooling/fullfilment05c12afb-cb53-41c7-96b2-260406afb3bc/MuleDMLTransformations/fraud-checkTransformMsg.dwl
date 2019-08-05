%dw 2.0
output application/xml inlineCloseOn="empty"
ns ns4 http://www.opentravel.org/OTA/2003/05/beta
ns stl18 http://webservices.sabre.com/pnrbuilder/v1_18
ns ns0 http://schemas.xmlsoap.org/soap/envelope/

var jsonReq=vars.originalReq.request

var reserRes = vars.reservationRS.GetReservationRS

fun getPassenger
(nameId) =  reserRes.Reservation.PassengerReservation.Passengers.*Passenger filter ((i,j) -> (i.@nameId == nameId))
fun getPassengerNS
(nameId) =  reserRes.Reservation.PassengerReservation.Passengers.*Passenger filter ((i,j) -> (i.@nameId == nameId)) 
 
fun getPassengerReferenceNumNS (nameId) = getPassengerNS(nameId).@referenceNumber[0]

fun getAncillaryService (RficSubcode) = (getAncillaryServiceNS(RficSubcode).TotalTTLPrice)[0]

fun getAncillaryServiceNS
(RficSubcode)= reserRes.Reservation.PassengerReservation.Passengers.*Passenger.AncillaryServices.AncillaryService filter ((i,j) -> (i.@id == RficSubcode))

---
{
	ns0#Envelope: {
		ns0#Body: {
	ns4#FraudCheckRQ @(
		"Version":"1.7.0"
	):{
		ns4#POS @(
			"PseudoCityCode":reserRes.Reservation.POS.Source.@PseudoCityCode,
			"StationNumber":"Station",
			"ISOCountry":reserRes.Reservation.POS.Source.@ISOCountry,
			"IP_Address": vars.httpAttributes.headers.host,
			"ChannelID":jsonReq.pos.channel,
			"LocalDateTime":jsonReq.pos.localDateTime
		):{
			ns4#BrowserDetail:{
				ns4#HttpHeaders: {
					(vars.httpAttributes.headers mapObject (value, key) -> {
						ns4#HttpHeader @(
							"Name":key
						):value
					})
				}
			}
		},
		ns4#MerchantDetail @("MerchantID": vars.originalReq.request.pos.company):{},
		ns4#OrderDetail @("RecordLocator": vars.originalReq.request.pnr) : {
			(jsonReq.orderDetails.passengerDetails map (item,index) -> {
				ns4#PassengerDetail @(
					"PsgrType": getPassengerReferenceNumNS(item.nameNumber)): {
						(jsonReq.ticketingData.emd.emdDocuments map (emdDocuments, docIndex) -> {
							(ns4#Document @("DocType":"EMD",
										"BaseFare":getAncillaryService(emdDocuments.aeItemId).Price
						):{}) if ( getPassenger(item.nameNumber).AncillaryServices.AncillaryService.@id[0] == emdDocuments.aeItemId)
						}) 
				}
		})},
		ns4#PaymentDetail:{
			ns4#FOP @("Type":"CC"):{},
			(jsonReq.paymentData.payments map (item, index) -> {
				ns4#PaymentCard @(
				"CardCode":item.cardCode,
				"CardNumber":item.cardNumber,
				"CardSecurityCode":item.cardSecurityCode,
				"ExpireDate":item.expirationDate):{
					ns4#CardHolderName @(
						"FirstName":item.cardHolder.firstName,
						"LastName":item.cardHolder.lastName
					):{}
				},
				ns4#AmountDetail @(
					"Amount":item.details.amount.value,
					"CurrencyCode":item.details.amount.currency
				):{}
			})
		},
		
	}
}
}
}