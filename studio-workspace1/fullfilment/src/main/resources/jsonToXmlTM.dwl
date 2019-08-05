%dw 2.0
output application/xml
ns ns0 http://schemas.xmlsoap.org/soap/envelope/
ns ns01 http://webservices.sabre.com/pnrbuilder/v1_18
---
{
	ns0#Envelope: {
		ns0#Body: {
			ns01#GetReservationRQ: {
				ns01#Locator: payload.request.pnr,
				ns01#RequestType: payload.request.orderDetails.passengerDetails."type",
				ns01#ReturnOptions: {
					ns01#ViewName: payload.request.orderDetails.passengerDetails.nameNumber,
					ns01#ResponseFormat: "application/xml"
				}
			}
		}
	}
}