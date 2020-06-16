# assignment1

Requirement:
1. pip3
2. ansible 2.8.5


How to ?
1. ansible-playbook -i ips play.yml --ask-pass # to find out free IPs and Ports
2. ansible-playbook -i ips deploy.yml --ask-pass # to deploy on free IPs based on port number

Description:
- Separate role should be defined based on the port and a dictionary entry must be added
- Free startegy has been used to poll the systems

* Recommend - Add ssh keys to all machines
