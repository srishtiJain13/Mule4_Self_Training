%dw 2.0
output application/xml inlineCloseOn="empty"
ns ns2 http://www.sabre.com/ns/Ticketing/misc/1.0
ns ns1 http://services.sabre.com/STL/v01
ns stl16 http://webservices.sabre.com/pnrbuilder/v1_16
ns ns0 http://schemas.xmlsoap.org/soap/envelope/

var jsonReq=vars.originalReq.request

fun getPassenger (nameId) =  (getPassengerNS(nameId).LastName)[0]

fun getPassengerNS
(nameId) =  payload.GetReservationRS.Reservation.PassengerReservation.Passengers.*Passenger filter ((i,j) -> (i.@nameId == nameId)) 

---
{
	ns0#Envelope: {
		ns0#Body: {
	ns2#CollectMiscFeeRQ @(
		"version":"1.4.1"
	): {
		ns1#AgentPOS @(
			"company":vars.originalReq.request.pos.company,
			"lniata":vars.originalReq.request.pos.lniata,
			"sine":vars.originalReq.request.pos.sine
		):{
			ns1#AAA:"ERF"
		},
		ns1#Transaction @("code":"EMD"):{},
		ns1#Parameters:{
			ns1#PrinterLniata: "*ETKT*"
		},
		(jsonReq.orderDetails.passengerDetails map (item, index) -> {
			ns1#Fees: {
			ns1#Linked:{
				ns1#Customer @(
					"lastName":getPassengerNS(item.nameNumber).LastName[0],
					"firstName": getPassengerNS(item.nameNumber).FirstName[0]
				):{
					ns1#CustomerDetails @(
						"nameRefNumber":item.nameNumber,
						"pnrLocator":vars.originalReq.request.pnr
					):{}
				},
				ns1#Fee :{
					(jsonReq.ticketingData.emd.emdDocuments map (emdDoc , docIndex) -> {						
						(ns1#FeeDetails @(
							"code":getPassengerNS(item.nameNumber).AncillaryServices.AncillaryService.RficSubcode[0],
							"quantity":1
						): {
							ns1#Base @(
								"currencyCode":getPassengerNS(item.nameNumber).AncillaryServices.AncillaryService.TTLPrice.Currency[0],
								"currency":getPassengerNS(item.nameNumber).AncillaryServices.AncillaryService.TTLPrice.Currency[0]
							):getPassengerNS(item.nameNumber).AncillaryServices.AncillaryService.TTLPrice.Price[0],
							ns1#TotalTax @(
								"currencyCode":getPassengerNS(item.nameNumber).AncillaryServices.AncillaryService.TTLPrice.Currency[0],
								"currency":getPassengerNS(item.nameNumber).AncillaryServices.AncillaryService.TTLPrice.Currency[0]
							):0,
							ns1#Total @(
								"currencyCode":getPassengerNS(item.nameNumber).AncillaryServices.AncillaryService.TTLPrice.Currency[0],
								"currency":getPassengerNS(item.nameNumber).AncillaryServices.AncillaryService.TTLPrice.Currency[0]
							): getPassengerNS(item.nameNumber).AncillaryServices.AncillaryService.TTLPrice.Price[0],							
						}) if(emdDoc.aeItemId == getPassengerNS(item.nameNumber).AncillaryServices.AncillaryService.@id[0])
					})
				}
			}
		}
	}),
		ns1#TotalCost @(
			"currencyCode":jsonReq.paymentData.payments[0].details.amount.currency,
			"currency":jsonReq.paymentData.payments[0].details.amount.currency
		):vars.originalReq.request.paymentData.payments[0].details.amount.value,
		ns1#Payment :{
			ns1#Amount @(
				"currencyCode":jsonReq.paymentData.payments[0].details.amount.currency,
			"currency":jsonReq.paymentData.payments[0].details.amount.currency
			):vars.originalReq.request.paymentData.payments[0].details.amount.value,
			ns1#FormOfPayment:{
				ns1#CreditCard @("transactionID":payload.PaymentRS.Results[0].AuthorizationResult.@SupplierTransID):{
					ns1#Code:jsonReq.paymentData.payments[0].cardCode,
					ns1#Number:jsonReq.paymentData.payments[0].cardNumber,
					ns1#ExpiryDate: (jsonReq.paymentData.payments[0].expirationDate)[5 to 6] ++ (jsonReq.paymentData.payments[0].expirationDate)[2 to 3] ,
					ns1#SecurityCode:jsonReq.paymentData.payments[0].cardSecurityCode,
					ns1#ApprovalCode:payload.PaymentRS.Results[0].AuthorizationResult.@ApprovalCode
				}
			}
		},
		ns1#DetailLevel:"Full"
		}
}
}
}