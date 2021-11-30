### General Instruction
- When you create project by clicking on *Use this template* icon, you will be require to update `SRE-MAC-CLIENT-CODE` submodule folder by clicking on *Actions -> Update-Core-Files* icon for master branch. This is an action which will raise pull request for master branch to push latest changes from [SRE-MAC-CLIENT-CODE](https://github.com/AmwayACS/SRE-MAC-CLIENT-CODE) repo. This actions also create *code-build/state.conf* file so that terraform can manage resource states.
- Clients need to keep in sync any new branch created together with preprod & production branch with master.

---
**Note** 

If `git submodule update` fail on your local machine (due to SSH based auth), in that case you may need to put below change in `.gitmodules` file only for running it successfully and **avoid committing** it
```
[submodule "SRE-MAC-CLIENT-CODE"]
	path = SRE-MAC-CLIENT-CODE
	url = git@github.com:AmwayACS/SRE-MAC-CLIENT-CODE.git
```	