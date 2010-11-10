%zewdCompiler18	; Slideshow Javascript
 ;
 ; Product: Enterprise Web Developer (Build 830)
 ; Build Date: Wed, 10 Nov 2010 13:15:09
 ; 
 ; ----------------------------------------------------------------------------
 ; | Enterprise Web Developer for GT.M and m_apache                           |
 ; | Copyright (c) 2004-10 M/Gateway Developments Ltd,                        |
 ; | Reigate, Surrey UK.                                                      |
 ; | All rights reserved.                                                     |
 ; |                                                                          |
 ; | http://www.mgateway.com                                                  |
 ; | Email: rtweed@mgateway.com                                               |
 ; |                                                                          |
 ; | This program is free software: you can redistribute it and/or modify     |
 ; | it under the terms of the GNU Affero General Public License as           |
 ; | published by the Free Software Foundation, either version 3 of the       |
 ; | License, or (at your option) any later version.                          |
 ; |                                                                          |
 ; | This program is distributed in the hope that it will be useful,          |
 ; | but WITHOUT ANY WARRANTY; without even the implied warranty of           |
 ; | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            |
 ; | GNU Affero General Public License for more details.                      |
 ; |                                                                          |
 ; | You should have received a copy of the GNU Affero General Public License |
 ; | along with this program.  If not, see <http://www.gnu.org/licenses/>.    |
 ; ----------------------------------------------------------------------------
 ;
 QUIT
 ;
 ;
slideshow ;
	;;***END***
ewdStyles
 ;;#ewdajaxonload {
 ;;   display:none;
 ;;}
 ;;#ewdscript {
 ;;   display:none;
 ;;}
 ;;.ewdSpinnerButtonUp[class] {
 ;;   background: #ffffff url(spinnerUp.gif) no-repeat;
 ;;   cursor : pointer ;
 ;;   position:relative;
 ;;   border-width: 2px;
 ;;   border-style: outset;
 ;;   height: 11px;
 ;;   width: 25px;
 ;;   top:0px;
 ;;   left(up):-4px
 ;;}
 ;;.ewdSpinnerButtonDown[class] {
 ;;   background: #ffffff url(spinnerDown.gif) no-repeat;
 ;;   position:relative; 
 ;;   cursor : pointer ;
 ;;   border-width: 2px;
 ;;   border-style: outset;
 ;;   height: 11px;
 ;;   width: 25px;
 ;;   top:11px;
 ;;   left(down):-33px ;
 ;;}
 ;;.ewdSpinnerButtonUp {
 ;;   background: #ffffff url(spinnerUp.gif) no-repeat;
 ;;   cursor : pointer ;
 ;;   position:relative;
 ;;   border-width: 2px;
 ;;   border-style: outset;
 ;;   height: 12px;
 ;;   width: 25px;
 ;;   top:-10px;
 ;;   left(up):-4px
 ;;}
 ;;.ewdSpinnerButtonDown {
 ;;   background: #ffffff url(spinnerDown.gif) no-repeat;
 ;;   position:relative; 
 ;;   cursor : pointer ;
 ;;   border-width: 2px;
 ;;   border-style: outset;
 ;;   height: 12px;
 ;;   width: 25px;
 ;;   top:0px;
 ;;   left(down):-33px ;
 ;;}
 ;;.ewdSpinnerText[class] {
 ;;   width:21px ;
 ;;}
 ;;.ewdSpinnerText {
 ;;   width:21px ;
 ;;}
 ;;.ewdDispOff {
 ;;    background : #ffffff ;
 ;;    border-style: outset ;
 ;;    border-width: 2px ;
 ;;    left:400px; 
 ;;    width: 300px;
 ;;    height:150px;
 ;;    position:absolute; 
 ;;    top:100px; 
 ;;    z-index:1;
 ;;    visibility : hidden ;
 ;;}
 ;;.ewdDispOn {
 ;;    background : #efffff ;
 ;;    border-style: outset ;
 ;;    border-width: 3px ;
 ;;    text-align : center ;
 ;;    left:400px; 
 ;;    width: 300px;
 ;;    height:150px;
 ;;    position:absolute; 
 ;;    top:160px; 
 ;;    visibility: visible; 
 ;;    z-index:10;
 ;;}
 ;;.tabs {
 ;;   cursor : pointer ; 
 ;;   height: 20px ;  
 ;;   background : transparent ; 
 ;;   text-align: center ; 
 ;;   position: relative ; 
 ;;   left: 5px ; 
 ;;   font-family : Arial, Helvetica, sens-serif ; 
 ;;   font-size: 11pt;
 ;;   position:relative;
 ;;   top: -2px;
 ;;   z-index:1 ;
 ;;}
 ;;.selectedTab {
 ;;   font-size:8pt ;
 ;;   border-style: solid ;
 ;;   border-width: 1px;
 ;;   background: #DCDCFA ; 
 ;;   padding-left: 3px ; 
 ;;   padding-right: 3px ;
 ;;   margin-right: 0px;
 ;;   border-color: #EBAB3C #EBAB3C #DCDCFA #EBAB3C;
 ;;}
 ;;.unselectedTab {
 ;;   font-size:8pt ;
 ;;   background: #fcfcfc ;
 ;;   border-style: solid;
 ;;   border-width: 1px ;
 ;;   padding-left: 3px ; 
 ;;   padding-right: 3px ;
 ;;   margin: 0px;
 ;;   border-color: #FFE2AF #FFE2AF #EBAB3C #FFE2AF ;
 ;;}
 ;;.highlightedTab {
 ;;   font-size:8pt ;
 ;;   background: #DCDCFA ;
 ;;   border-style: solid;
 ;;   border-width: 1px ;
 ;;   padding-left: 3px ; 
 ;;   padding-right: 3px ;
 ;;   margin: 0px;
 ;;   border-color: #FFE2AF #FFE2AF #EBAB3C #FFE2AF ;
 ;;}
 ;;.mainTabMenuPanel {
 ;;   background : #DCDCFA ; 
 ;;   text-align: left ; 
 ;;   position: relative ; 
 ;;   top: -5px;
 ;;   left: 0px ; 
 ;;   width : 95% ; 
 ;;   height: auto ; 
 ;;   font-family : Arial, Helvetica, sens-serif ; 
 ;;   font-size: 12pt ; 
 ;;   border-style: solid;
 ;;   border-width:1px;
 ;;   border-color: black;
 ;;   border-left: 1px #FFE2AF dotted ; 
 ;;   border-right: 1px #FFE2AF dotted ;
 ;;   border-top-color: #EBAB3C ;
 ;;   padding: 10px 20px 10px 20px;
 ;;}
 ;;.innerTabs {
 ;;   cursor : pointer ; 
 ;;   height: 20px ;  
 ;;   background : transparent ; 
 ;;   text-align: center ; 
 ;;   position: relative ; 
 ;;   left: 4px ; 
 ;;   font-family : Arial, Helvetica, sens-serif ; 
 ;;   font-size: 10pt;
 ;;   position:relative;
 ;;   top: -7px;
 ;;   z-index:1 ;
 ;;}
 ;;.selectedInnerTab {
 ;;   font-size:8pt ;
 ;;   width:auto;
 ;;   border-style: solid ; 
 ;;   border-width:1px;
 ;;   background: #FFEEEA ; 
 ;;   padding-left: 3px ; 
 ;;   padding-right: 3px ;
 ;;   margin-right: 0px;
 ;;   border-color: black black #FFE4E4 black;
 ;;}
 ;;.highlightedInnerTab {
 ;;   font-size:8pt ;
 ;;   background: #FFEEEA ;
 ;;   border-style: solid;
 ;;   border-width: 1px 1px 1px 1px ;
 ;;   padding-left: 3px ; 
 ;;   padding-right: 3px ;
 ;;   margin: 0px;
 ;;   border-color: #aaaaaa #999999 black #aaaaaa;
 ;;}
 ;;.unselectedInnerTab {
 ;;   font-size:8pt ;
 ;;   background: #E8E0E2 ;
 ;;   border-style: solid;
 ;;   border-width: 1px 1px 1px 1px ;
 ;;   padding-left: 3px ; 
 ;;   padding-right: 3px ;
 ;;   margin: 0px;
 ;;   border-color: #aaaaaa #999999 black #aaaaaa;
 ;;}
 ;;    .innerPanel {
 ;;      height: auto;
 ;;      width: 98% ;
 ;;      background-color: #FFEEEA ;
 ;;      vertical-align: top ;
 ;;      margin-left: 5px;
 ;;      margin-right: 5px;
 ;;      margin-top: 0px;
 ;;      margin-bottom: 5px;
 ;;      padding-top: 10px;
 ;;      padding-left:10px;
 ;;      position:relative;
 ;;      top: -10px;
 ;;      border-style: solid ; 
 ;;      border-width: 1px ;
 ;;      border-color : #000000 ;
 ;;    }
 ;;.ewdPresTitle {
 ;;  font-family : Arial, Helvetica, sens-serif ; 
 ;;  text-align: center ;
 ;;  font-size: 28pt ;
 ;;  font-weight: bold;
 ;;  line-height: 70px;
 ;;}
 ;;.ewdPresLevel1 {
 ;;  font-family : Arial, Helvetica, sens-serif ; 
 ;;  font-size: 20pt ;
 ;;  line-height: 50px;
 ;;  padding-left: 10px;
 ;;}
 ;;.blueFade {
 ;;   background : #ffffff ; 
 ;;   background-image : url(bgfade_small.gif);
 ;;   background-position : top ;
 ;;   background-repeat: repeat-x;
 ;;}
 ;;.cpScrollArea{
 ;;        height:100;
 ;;        width:200;
 ;;        overflow:auto;
 ;;        display : none ;
 ;;}
 ;;.cpScrollAreaOn{
 ;;        height:100;
 ;;        width:180;
 ;;        overflow:auto;
 ;;        background-color: #ffffff;
 ;;        border: solid #000000;
 ;;        border-width: 1px 1px 1px 1px;
 ;;        visibility: visible; 
 ;;        z-index:1;
 ;;        position:absolute;
 ;;        top: 0 ;
 ;;        left: 0 ;
 ;;        font-family: Arial;
 ;;        font-size: 10pt;
 ;;}
 ;;.cpSelButton{
 ;;        margin: 0px 0px 0px 0px; 
 ;;        position: relative ; 
 ;;        left: -5px ; 
 ;;        top: -1px ;
 ;;        border-bottom: 1px solid #666;
 ;;        border-right: 1px solid #666;
 ;;	       border-top: 1px solid #ccc;
 ;;        border-left: 1px solid #ccc;
 ;;        background-color: #dfd0ff;
 ;;        font-size: 12px;
 ;;        color: #333333;
 ;;        font-weight: bold;
 ;;        padding: 1px 2px 2px 2px;
 ;;}
 ;;.cpHlOn{
 ;;        background-color: #00008B;
 ;;        color: #ffffff;
 ;;        font-family: Arial;
 ;;        font-size: 10pt;
 ;;}
 ;;.cpHlOff{
 ;;        background-color: #ffffff;
 ;;        color: #000000;
 ;;        font-family: Arial;
 ;;        font-size: 10pt;
 ;;}
 ;;.divSlideLeft {
 ;;        -webkit-animation-name: "slide-to-the-left";
 ;;        -webkit-animation-duration: 600ms;
 ;;}
 ;;@-webkit-keyframes "slide-to-the-left" {
 ;;
 ;;        from { left: 0px; }
 ;;        to { left: -320px; }
 ;;}
 ;;.divContent {
 ;;  position: relative;
 ;;  min-height: 250px;
 ;;  margin-top: 10px;
 ;;  height: auto;
 ;;  z-index: 0;
 ;;  overflow: hidden;
 ;;  width: 320px;
 ;;  left: 0px;
 ;;}
 ;;.datefield{
 ;;   color:blue;
 ;;   float:right;
 ;;   position:relative;
 ;;   top:12px;
 ;;   right:10px;
 ;;}
 ;;***END*** 
 ;;
