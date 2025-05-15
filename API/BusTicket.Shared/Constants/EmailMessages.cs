namespace BusTicket.Shared
{
    public class EmailMessages
    {
        public const string ResetPasswordSubject = "BusTicket Team | Resetovanje lozinke";
        public const string ConfirmationEmailSubject = "BusTicket Team | Dodjela korisničkog naloga";
        public const string Notification = "BusTicket Team | Obavijest";
        public const string ClientEmailSubject = "BusTicket Team | Dodjela uloge klijenta";
        public const string NewQuestionnaireSubject = "BusTicket Team | Novi upitnik";
        public static string GeneratePasswordEmail(string name, string password)
        {
            string body =
                $"""
        <div style='text-align:center; padding:20px;'>
            <img src='https://img.freepik.com/free-vector/students-bus-transport_24877-83776.jpg?t=st=1746550099~exp=1746553699~hmac=db3b3e78b6b5481c99531c325ab2fe050bd22aed26c2f285649777133e8c9c2d&w=826' alt='BusTicket Logo' style='height:60px; margin-bottom:20px;'/>
            
            <h1 style='color:#2c3e50; font-size:24px; margin-bottom:25px;'>Dobrodošli na BusTicket sistem, {name}!</h1>
            
            <div style='background-color:#f8f9fa; border-radius:8px; padding:20px; margin:0 auto; max-width:400px;'>
                <p style='color:#555; font-size:16px; margin-bottom:15px;'>Vaš račun je uspješno kreiran.</p>
                
                <div style='background-color:#fff; border:1px dashed #78498d; border-radius:6px; padding:15px; margin:15px 0;'>
                    <p style='color:#777; font-size:14px; margin:0 0 8px 0;'>Privremena lozinka:</p>
                    <p style='font-size:20px; font-weight:bold; color:#2c3e50; letter-spacing:1px; margin:0;'>{password}</p>
                </div>
                
                <p style='color:#555; font-size:14px;'>
                    Molimo Vas da pri prvoj prijavi promijenite ovu lozinku.
                </p>
            </div>
            
            <p style='color:#7f8c8d; font-size:14px; margin-top:30px; line-height:1.5;'>
                Ako niste kreirali ovaj račun, molimo ignorirajte ovaj email.<br>
                Lozinku nikome ne dijelite i čuvajte je na sigurnom mjestu.
            </p>
        </div>
        """;

            return EmailWrapper.WrapBody(body);
        }

        public static string GenerateResetPasswordEmail(string name, string password, string clientUrl)
        {
            string body =
                $"<p style='text-align:center;color:black'>Poštovani {name},</p>" +
                $"</br>" +
                $"<div style='text-align:center;'>" +
                $"<span style='text-align:center;color:black'>Uspješno ste resetovali šifru na aplikaciji</span> " +
                $"<span style='font-weight:bold;display:inline;'>BusTicket</span>." +
                $"</div>" +
                $"</br>" +
                $"<div style='text-align:center;'>" +
                $"<span style='text-align:center;color:black'>Vaša nova lozinka je:</span>" +
                $"<span style='font-weight:bold;display:inline'> {password}</span>" +
                $"</div>" +
                $"</br>" +
                $"</br>" +
                $"<a style='display:block; width:40%; margin:auto; cursor:pointer;' href='{clientUrl}/login'> " +
                $"<button style='background-color:#0067b8;color:white;width:100%;height:30px;text-align:center;border-radius:5px; cursor:pointer;'>" +
                $"Prijava" +
                $"</button>" +
                $"</a>" +
                $"<p style='text-align:center; color:black'>Uživajte u korištenju aplikacije.</p>";

            return EmailWrapper.WrapBody(body);
        }

        public static string GenerateNotificationEmail(string name, string message)
        {
            string body =
                $"""
        <div style='text-align:center; padding:20px;'>
            <img src='https://img.freepik.com/free-vector/students-bus-transport_24877-83776.jpg?t=st=1746550099~exp=1746553699~hmac=db3b3e78b6b5481c99531c325ab2fe050bd22aed26c2f285649777133e8c9c2d&w=826' 
                alt='BusTicket Logo' style='height:60px; margin-bottom:20px;'/>
            
            <h1 style='color:#2c3e50; font-size:24px; margin-bottom:25px;'>Poštovani, {name}</h1>
            
            <div style='background-color:#f8f9fa; border-radius:8px; padding:20px; margin:0 auto; max-width:500px;'>
                <p style='color:#555; font-size:16px; line-height:1.5;'>{message}</p>
            </div>
            
            <p style='color:#7f8c8d; font-size:14px; margin-top:30px; line-height:1.5;'>
                Hvala Vam što koristite BusTicket sistem.<br>
                Za sva dodatna pitanja možete nam se obratiti putem aplikacije.
            </p>
        </div>
        """;

            return EmailWrapper.WrapBody(body);
        }
    }
}
