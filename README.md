# IBMIMBI
Research on IBM i and an **IBM i native Open Source** concept

## Open Source for IBM i
If you look at the 5770-WDS list of options you will notice that there is no reference to an **ILE CL compiler**. 
<br/>If you execute a `DSPCMD CMD(CRTBNDRPG)` and a `DSPCMD CMD(CRTBNDCL)` you will also notice that, while *CRTBNDRPG* is a 'proxy' command, *CRTBNDCL* is a real one.

*Developing with ILE CL is inherently part of the IBM i Operating System!*

This made me realize that defining *IBM i native Open Source* should take these aspects into consideration. So I started exploring which are the *\"development\"* tools included (at no extra-charge) in the IBM i Operating System (i.e. inside **5770SS1**).

And finally I came to the fundamental question: *Is it possible to develop an IBM i Open Source Tools Suite on top of this **minimum ILE enablement**?*

It seems to me that developing on top of these stringent boundaries offers the kind of *freedom* the \*nix Open Source developers experienced years ago.


In the AIX world **GCC** is currently based on the **AIX native assembler** rather than on the **Gnu Assembler**. There were attempts to extend the Open Source domain in AIX by porting *GNU Assembler*, *GNU Linker* and *GNU Binutils*. GCC developers actually succeeded in bootstrapping GCC on **AIX 5**. Unfortunately, the GNU Assembler has not been updated to support **AIX 6** nor **AIX 7**. 

Here's my point: if we accept the idea of an AIX/PASE GCC dependent on AIX native **xcoff** tools, why shouldn't we accept the idea of developing Open Source for ILE on top of ILE CL?

I do not consider RPG ILE a reasonable language to develop Open Source tools for IBM i. Adopting ILE C/C++ would not work either. 

ILE CL seems the only one I would consider if we are to reinterpret the concept of Open Source in a  **native** IBM i environemnt.    


## The Non\-Programmable Terminal
The roots of IBM i (S/38, AS/400) are tied to programming for 5250 
(the **NPT**, *Non\-Programmable Terminal*). 
With the introduction of Power processors there was an attempt to redesign the fundamentals of the Operating System, opening the platform to usage scenarios different from administrative tasks. 
<br/>This offered new opportunities but never introduced a plain evolutionary path to richer user interfaces. 

After many years, the struggling behind many *Modernization* projects is still there, -I would say- unchanged.
 
<br/>When *Apache* was introduced in IBM i the new *mantra* was explaining that the future would have been in **stateless\-applications**. And actually ended up to be. 

But this triggered a never\-ending up\-scaling of business dimensions to stay competitive in the new architectural model.

In this new environment we are still longing for a stable business application development framework for simplier but reliable **statefullness**. 


## ILE CL and UIM
The Operating System standardized developing for the NPT with **\*PNLGRP** objects.
This support obviously predates *ILE* but current ILE CL offers the support needed to develop **exit programs** suited for the UIM environment. The objective of this repository is to demostrate this possibility. An ILE CL based open source develpment could initially cover the traditional 5250 tooling requirement. 

### clever use of INCLUDE statement
I created a set of small source file members ready to call UIM APIs. 
The effect of including these CL chuncks is actually to perform CALL statements with a pre-assigned set of CL variables as parameters for the UIM APIs.
My convention was to name the include file consistent with the API  names (with alternative names for different sets of parameters: e.g. compare QUIDSPP1 with QUIDSPP).

I checked that **MONMSG** statements can directly follow the **INCLUDE** ones for appropriate handling of errors.

The set of variables required by all APIs is declared in **QUINCLUDE** source file member. Other tricks are used to simplify declaring parameters for exit calls implementation. The current package is actually a testing suite for the **AndreaRibuoli/QUINCL** repository that provides the mentioned source members.


*Machine Language*
<br/>For **OPM** program model there has been a programming environment that -although low\-level- became quite common years ago. I am referring to the *AS/400 Machine\-Level Programming* (that is also the title of a detailed *hacker\-oriented* soft\-book written by *Leif Svalgaard*).

Actually, when ILE was introduced, at V2R3, 

<cite>original process model and ILE process model coexisted in the AS/400 until the appearence of the RISC processors. The RISC processor systems support only the ILE program and process models. **Both the ILE program and process models were created with the RISC processors in mind**.
</cite> 

( Frank G. Soltis *FORTRESS Rochester*, page 225)

As soon as V2R3 had its general availability in 1993 the idea of migrating to RISC appears pretty old: from the perspective of Rochester it all started in the early 90s.

Curiously, this same idea was discussed in IBM **during the summer of 1971** (!!!) as explained by [John F. Sowa](http://www.jfsowa.com/computer/). Many of the architectural innovations embodied in IBM i have roots in a distant past inside IBM research. 

I was impressed to find a clear description of what we call **TIMI** (Technology-Independent Machine Interface) in an IBM document of 1971 under the name of **HLS (Higher Level System) Interface**.



## Installation with PASERIE installer
`system 'PASERIE/INSTALL GIT_USER(AndreaRibuoli) PACKAGEN(IBMIMBI)'`
