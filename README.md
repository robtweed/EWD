# EWD
 
EWD is a Free Open Source Ajax Framework for GT.M

Build 855

This build includes an optional Node.js replacement for the m_apache service which you'll find in the 
*node* subdirectory.  To use this:

   - ensure that you have installed and configired Node.js
   - copy /node/mapache.js to the directory in which you run GT.M, eg /usr/local/gtm/ewd
   - edit mapache.js if required to adjust the parameters (defined near the top)
   - start the mapache service using: node mapache.js
   
   Modify the URL you use to invoke your EWD application(s) by adding the HTTP port used by mapache.js, eg:
   
      http://192.168.1.130:8081/ewd/myApp/index.ewd


## License

Copyright (c) 2004-11 M/Gateway Developments Ltd,
Reigate, Surrey UK.
All rights reserved.

http://www.mgateway.com
Email: rtweed@mgateway.com

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.




    


