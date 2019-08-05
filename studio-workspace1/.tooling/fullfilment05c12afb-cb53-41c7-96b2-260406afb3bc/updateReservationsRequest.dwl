%dw 2.0
output application/xml
ns ns0 http://schemas.xmlsoap.org/soap/envelope/
ns ns01 http://webservices.sabre.com/pnrbuilder/v1_18
---
{
	ns0#Envelope: {
		ns0#Body: {
			ns01#UpdateReservationRQ: {
				ns01#RequestType: "Stateless",
				ns01#ReturnOptions: "ABC",
				ns01#ReservationUpdateList: {
					ns01#Locator: "QTWMUM",
					ns01#ReservationUpdateItem:[
						ns01#RemarkUpdate: {
							ns01#RemarkText:"AUTH-PSS/AX5550/23AUG/01811535009367409119"
					}]
					
				}
			}
		}
	}
}