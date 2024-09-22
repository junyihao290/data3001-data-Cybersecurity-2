Project title: Improving Network Security by Classifying IoT Devices Based on Network Traffic Data Analysis 

Project description:  
IoT devices have become increasingly integrated into daily lives and work environments as time goes on. Duarte (2024) highlights that more than 15 billion IoT devices are connected worldwide as of 2024, and predicts that the number will rise continuously. However, its security risks are becoming increasingly significant with the popularity of devices, where the use of weak passwords or default passwords and open insecure service ports are considered two of the most significant vulnerabilities. At the same time, the security risks of IoT devices are exacerbated since household users do not master the necessary security knowledge (Pashamokhtari et al., 2023). To address such issues, our project focuses on analysing the network data and weeding out any potential security vulnerabilities through the identification of common patterns in network activity and the recognition of abnormal activity. The importance of this project is that it will ultimately aid in protecting IoT ecosystems from cybersecurity attacks and breaches. 

This project builds on the research in 2021 and 2023. The research in 2021 recognized device types by analyzing nat-post IPFIX traffic data. This project also uses the idea of analyzing IPFIX data to monitor the network behavior of devices, but the project has higher device visibility and focuses on improving network security. The research in 2023 adds the concept of "concept drift", and the data for this project also involves dynamic changes.

Sources:  
The project dataset contains IPFIX traffic records from 25 different IoT devices in the home network collected in the NAT-pre-environment from June 25, 2019, to October 10, 2019. The datasets consist of various fields capturing the characteristics of network flows. 


Data description:


Workflow:
To process the data so that it can be handled easily by the modelling team, we are cleansing it by removing irrelevant data, handling missing values and ensuring consistency of key fields.  

A combination of R and Alteryx are to be used in the cleansing process. To begin with, we remove any rows with all fields as NULL. Then, each type of information in the dataset is handled separately and cleansed as mentioned in the following steps: 

1. Timestamp and Timing fields:
Ensuring there are no negative values or inconsistent duration for these fields. We remove any rows with extremely short or long durations which may indicate noise or erroneous data. Also, given that the dataset will be further divided into three different subsets (training, validaition and testing) based on time sequence, we will also re-order the dataset accordingly to ensure proper sequencing. 

2. IP Address, MAC Addresses and Port Information:
Eliminating rows with invalid or malformed IP addresses, such as non-routable internal IPs and port numbers.
  
3. Packet and traffic information:
Removing any negative or 0 packet counts as they are invalid. We will also look for outliers in traffic volume by plotting box plots and eliminate them.

4. TCP Sequence Information and TCP Flags:
We need to ensure that sequence numbers are within expected ranges and investigate those which may be resets or retransmissions. TCP Flags are useful in identifying specific types of traffic or anomalies, for example, excessive SYN Flags.

5. Network Interfaces and VLANs:
We will check for inconsistencies between ingress and egress interfaces. 

6. Flow and Traffic Classification: 
We will look for unexpected application labels or reasons for flow termination.

7. Inter-arrival Times and Payload Statistics: 
We wil need to clean up missing or 0 values. Any outlier detected after plotting box plots will be removed as they indicate performance issues or potential threats.

8. Collector Information:
We will remove any inconsistent collector names and IDs as they might lead to corrupted entries.  


Project status:

At this stage, we have  performed a brief analysis of the available dataset in relation to its basic features and therefore proposed a systematic approach to perform cleansing for our raw dataset. 

More importantly, we have envisaged some fundamental features our final data product. We have also provided a strong justification on why this product is highly helpful to our client and outlined key objectives for this project. 

Further execution regarding the aforementioned steps of cleansing is still required, and this will be performed by every member of the team (each member will be responsible to 1 or 2 steps). This is a comprehensive step that requires significant amount of coding, and it is believed that we will work as a team to perform the cleansing. 

In terms how our data product could be employed for further analysis and modelling, logistic regression may be most desirable. However, it is not intended to have one model that will be able to perform all the classifications. This will be highly complex and may be prone to overfitting. Instead, we envisage that, for each classification, a model is employed to determine if the input data falls within the particular category. It is possible for an entry of data to generate positive outcomes from different models such that it points to different classifications. For such entrys, close analysis may be required as it is beyond the capability of our models to determine such classifications. Otherwise, these models will effectively classify the input data into different types of devices. On another note, it will be unlikely for all models to have the same set of key independent variables. This is for the simple reason that some independent variables may have strong explanatory and predictive force for some devices, but not others.

Contribution:

The project description and data description was co-written by Vishwa and Wanyue.
The workflow was written by Shivani Kadiyala. Each specific stage of workflow would be allocated to each team member for further execution. 
The project status was written by Jacky Gan. Jacky is also responsible for any proofreading and editing. 
The contrbution part was written by Junyi Hao.
