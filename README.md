# EWD
 
EWD is a Free Open Source Ajax Framework for GT.M

Thanks to:

- The Health Informatics Service, Calderdale & Huddersfield NHS Foundation Trust for sponsoring development and documentation of the ExtJS tag library
- Oroville Hospital, CA, for sponsoring development of the ExtJS Charts tags
- Bug fixes and enhancements suggested by, identified by, and/or provided by:
  - Mike Clayton & Ryan Eastman, Quest Diagnostics
  - David Wicksell
  - Zach Gonzales, Oroville Hospital
  - Chris Casey
  - Kiyoshi Sawada
  - Nikesh Gogia

Build 917: Main changes

- ExtJS Charts support
- Enhancements to and bug fixes for ExtJS v4
- Support infrastructure for SMART Apps (http://smartplatforms.org) 

#Previous Build Notes

Build 912 included:

- ExtJS version 4 Custom Tags
- David Wicksell's enhancements to XML/XSLT handling

Build 896 included:

- Automatic clear-down of symbol table after users' scripts terminate
- Copyright date update to 2012
- David Wicksell's enhancements to Sencha Touch tags

Build 894 included:

Websockets support: bug fixes
Use with build 22 of ewdGateway.js

Build 892 included:

- Cross-site scripting protection using output encoding
- various ExtJS bug fixes
- enhancements to the Node.js-based ewdGateway, including the ability to 
  modify parameters via the ^zewd("ewdGateway") global

Build 885 includes a new, optional Realtime web capability that makes use of Node.js to provide
the webserver and gateway to GT.M.  See [https://github.com/robtweed/ewdGateway](https://github.com/robtweed/ewdGateway) for full details.

Build 877 removes a rogue break, fixes a CSP-specific error in ExtJS forms, and also adds the ability to 
switch apps using an additional parameter for the setRedirect command:

 do setRedirect^%zewdAPI("myPage",sessid,"newApp")

 and to reset:
 
 do changeApp^%zewdAPI("oldApp",sessid)

## License

Copyright (c) 2004-11 M/Gateway Developments Ltd,
Reigate, Surrey UK.
All rights reserved.

http://www.mgateway.com
Email: rtweed@mgateway.com

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.




    


