namespace BusTicket.Shared;

public class EmailWrapper
{
    public static string WrapBody(string content)
    {
        return $"""
                    <html>
                    <body>
                        <div style='width:70%;margin:auto;background-color:whitesmoke;margin-top:10px;max-width:640px;
                                    box-shadow:0 1px 5px rgba(0,0,0,0.1);border-radius:4px;overflow:hidden;padding:15px;
                                    font-family:"Segoe UI Webfont",-apple-system,"Helvetica Neue","Lucida Grande","Roboto",
                                                 "Ebrima","Nirmala UI","Gadugi","Segoe Xbox Symbol","Segoe UI Symbol",
                                                 "Meiryo UI","Khmer UI","Tunga","Lao UI","Raavi","Iskoola Pota","Latha",
                                                 "Leelawadee","Microsoft YaHei UI","Microsoft JhengHei UI","Malgun Gothic",
                                                 "Estrangelo Edessa","Microsoft Himalaya","Microsoft New Tai Lue",
                                                 "Microsoft PhagsPa","Microsoft Tai Le","Microsoft Yi Baiti","Mongolian Baiti",
                                                 "MV Boli","Myanmar Text","Cambria Math";'>

                            <div style='color:black'>
                                {content}
                                <br />
                                <hr style='background-color:#78498d9e;border:none;height:0.5px;' />
                                <p style='color:#747F8D; font-size:13px; line-height:16px; text-align:left;'>
                                    Ova e-pošta je automatski generisana. Molimo Vas da ne odgovarate na ovu poruku.
                                </p>
                                <div style='text-align:left;'>
                                    <span style='color:black;'>Lijep pozdrav,</span>
                                    <span style='font-weight:bold; color:black;'>BusTicket Team</span>
                                </div>
                            </div>
                        </div>
                    </body>
                    </html>
                """;
    }

}
