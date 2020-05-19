# IBMIMBI
Research on IBM i and *IBM i native Open Source* concept

## Open Source for IBM i
If you look at the 5770-WDS list of options you will notice that there is no reference to an **ILE CL compiler**. 
<br/>If you execute a `DSPCMD CMD(CRTBNDRPG)` and a `DSPCMD CMD(CRTBNDCL)` you will also notice that, while *CRTBNDRPG* is a 'proxy' command, *CRTBNDCL* is a real one.

*Developing with ILE CL is inherently part of the IBM i Operating System offering!*

This made me realize that defining *IBM i native Open Source* should take these aspects into consideration. So I started exploring which are the *\"development\"* tools included (at no extra-charge) in the IBM i Operating System (i.e. inside **5770SS1**).

And finally I came to the fundamental question: *Is it possible to develop an IBM i Open Source Tools Suite on top of this **minimum ILE enablement**?*

It seems to me that developing on top of these stringent boundaries offers the kind of *freedom* the \*nix Open Source developers experienced years ago.

*Machine Language*
<br/>For **OPM** program model there has been a programming environment that -although low\-level- became quite common years ago. I am referring to the *AS/400 Machine\-Level Programming* (that is also the title of a detailed *hacker\-oriented* soft\-book written by *Leif Svalgaard*).

In the AIX world **GCC** is currently based on the **AIX native assembler** rather than on the **Gnu Assembler**. There were actually attempts to extend the Open Source domain in AIX by porting *GNU Assembler*, *GNU Linker* and *GNU Binutils*. GCC developers actually succeeded in bootstrapping GCC on **AIX 5**. Unfortunately, the GNU Assembler has not been updated to support **AIX 6** nor **AIX 7**. 

My point is this: if we accept the idea of AIX/PASE GCC depending on AIX native **xcoff** tools why shouldn't we accept the idea of developing Open Source for ILE on top of ILE CL? And -eventually- MI?

I do not consider RPG ILE a reasonable language to develop Open Source tools for IBM i. Adopting ILE C/C++ would not work either. ILE CL and MI source code are the only ones I would consider if we are to reinterpret the concept of Open Source in **native** IBM i .    


## The Non\-Programmable Terminal
The roots of IBM i (S/38, AS/400) are tied to programming for 5250 
(the **NPT**, *Non\-Programmable Terminal*). 
With the introduction of Power processors there was an attempt to redesign the fundamentals of the Operating System, opening the platform to usage scenarios different from administrative tasks. 
<br/>This offered new opportunities but never introduced a plain evolutionary path to richer user interfaces. 

After many years, the struggling behind many *Modernization* projects is still there, -I would say- unchanged.
 
<br/>When *Apache* was introduced in IBM i the new *mantra* was explaining that the future would have been in **stateless\-applications**. And actually ended up to be. But this triggered a never\-ending up\-scaling of business dimensions to stay competitive in the new architectural model.

In this new environment we are still longing for a stable business application development framework for simplier but reliable **statefullness**. 


## ILE CL and UIM
The Operating System standardized developing for the NPT with **\*PNLGRP** objects.
This support obviously predates *ILE* but current ILE CL offers the support needed to develop **exit programs** suited for the UIM environment. The objective of this repository is to demostrate this possibility.

### clever use of INCLUDE statement
I created a set of small source file members ready to call UIM APIs. 
The effect of including such a member is actually to perform the call statement with a pre-assigned set of CL variables as parameters.
The convention is to name the include as the API itself (with alternative names for different sets of parameters: e.g. refer to QUIDSPP1 .vs. QUIDSPP).
Eventual **MONMSG** statements can directly follow the **INCLUDE** ones.
The set of variables required by all APIs is declared in **QUINCLUDE** source file member.
Other tricks are used to simplify declaring parameters for exit calls implementation. 

This package is actually a testing example for the **AndreaRibuoli/QUINCL** repository.


<!--
## Let us suppose...
Let us suppose that such a framework is still technically feasible but technology companies consider it unwelcomed, simply because they know they would not retain much control in the evolution of hardware and software demand.
-->


## Installation with PASERIE installer
`system 'PASERIE/INSTALL GIT_USER(AndreaRibuoli) PACKAGEN(IBMIMBI)'`
