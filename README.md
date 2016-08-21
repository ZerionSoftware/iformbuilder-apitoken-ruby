# iformbuilder-apitoken-ruby

<p>Package is designed to help jumpstart development with iFormBulder API by providing an easy interface for generating access tokens.</p> 

<h2>Example Use:</h2>


<pre>

# instantiate TokenResolver with required parameters and call get_token method

require './auth/token_resolver.rb'

client = 'your_client'
secret = 'you_secret'
url = 'https://your_server.iformbuilder.com'

token = Iform::TokenResolver.new().get_token url, client, secret

</pre>

<h2>API Access Requirement</h2>

<p>See how to find your credentials: <a href="https://iformbuilder.zendesk.com/hc/en-us/articles/201702900-What-are-the-API-Apps-Start-Here-">here</a></p>

<h2>Licenses</h2>
<a href="http://opensource.org/licenses/MIT">MIT (open source)</a>
