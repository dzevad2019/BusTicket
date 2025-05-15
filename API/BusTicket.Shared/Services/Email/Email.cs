using System.Net;
using System.Net.Mail;
using System.Text;

namespace BusTicket.Shared
{
    public class Email : IEmail
    {
        private readonly string _host;
        private readonly int _port;
        private readonly int _timeout;
        private readonly string _username;
        private readonly string _password;
        private readonly string _displayName;
        private readonly string _fromAddress;
        private readonly bool _enableSSL;

        public Email()
        {
            _host = Environment.GetEnvironmentVariable("SMTP_SERVER") ?? "smtp.gmail.com";
            _port = int.Parse(Environment.GetEnvironmentVariable("SMTP_PORT") ?? "587");
            _timeout = int.Parse(Environment.GetEnvironmentVariable("MAIL_TIMEOUT") ?? "10000");
            _enableSSL = bool.Parse(Environment.GetEnvironmentVariable("ENABLE_SSL") ?? "true");
            _username = Environment.GetEnvironmentVariable("SMTP_USERNAME") ?? "zahirovic2019@gmail.com";
            _password = Environment.GetEnvironmentVariable("SMTP_PASSWORD") ?? "exhi eova akph ghfa";
            _displayName = Environment.GetEnvironmentVariable("MAIL_DISPLAY_NAME") ?? "busticket.ba";
            _fromAddress = Environment.GetEnvironmentVariable("MAIL_FROM_ADDRESS") ?? "no-replay@busticket.ba";
        }

        public async Task Send(string subject, string body, string toAddress, Attachment attachment = null)
        {
            await Send(subject, body, new[] { toAddress }, attachment);
        }

        public async Task Send(string subject, string body, string[] toAddresses, Attachment attachment = null)
        {
            using (var smtpClient = new SmtpClient
            {
                Port = _port,
                Host = _host,
                Timeout = _timeout,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(_username, _password),
                EnableSsl = _enableSSL
            })
            {
                foreach (var address in toAddresses)
                {
                    try
                    {
                        var mailMessage = new MailMessage(new MailAddress(_fromAddress, _displayName), new MailAddress(address))
                        {
                            Subject = subject,
                            Body = body,
                            IsBodyHtml = true,
                            BodyEncoding = Encoding.UTF8,
                            DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure
                        };

                        if (attachment != null)
                        {
                            mailMessage.Attachments.Add(attachment);
                        }

                        await smtpClient.SendMailAsync(mailMessage);

                    }
                    catch (Exception)
                    {
                        throw;
                    }
                }
            }
        }
    }
}
