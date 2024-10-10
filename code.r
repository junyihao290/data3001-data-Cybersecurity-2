process_dataset <- function(dataset) {
    is_valid_ipv4 <- function(ip) {
        parts <- strsplit(ip, "\\.")[[1]]  
        if (length(parts) != 4) return(FALSE) 
        for (part in parts) {    
            if (!grepl("^\\d+$", part)) return(FALSE)  
            num <- as.numeric(part)
            if (num < 0 || num > 255) return(FALSE)  
            if (nchar(part) > 1 && substr(part, 1, 1) == "0") return(FALSE)  
        }
        return(TRUE)
    }
    dataset <- dataset[sapply(dataset$sourceIPv4Address, is_valid_ipv4), ]
    dataset <- dataset[sapply(dataset$destinationIPv4Address, is_valid_ipv4), ]
    dataset <- dataset %>%
        select(-ingressInterface, -egressInterface, -vlanId, -silkAppLabel, -observationDomainId, -collectorName) 
    dataset <- dataset %>%
        mutate(flowEndReason = ifelse(flowEndReason == "" | is.na(flowEndReason), "NR", flowEndReason))
    dataset <- dataset %>%
        filter(!(protocolIdentifier == 6 & if_any(everything(), is.na)))
    important_vars <- c("flowStartMilliseconds", "flowEndMilliseconds", "sourceIPv4Address", 
                        "destinationIPv4Address", "sourceTransportPort", "destinationTransportPort", 
                        "protocolIdentifier", "tcpSequenceNumber", "reverseTcpSequenceNumber")
    dataset <- dataset %>%
        filter(complete.cases(select(., all_of(important_vars))))
    dataset <- dataset %>%
        mutate(across(c("initialTCPFlags", "reverseInitialTCPFlags", "unionTCPFlags", "reverseUnionTCPFlags"), 
                      ~replace_na(., "NF")))
   
    count_vars <- c("packetTotalCount", "reversePacketTotalCount", "octetTotalCount", 
                    "reverseOctetTotalCount", "smallPacketCount", "reverseSmallPacketCount", 
                    "largePacketCount", "reverseLargePacketCount", "reverseTcpUrgTotalCount", 
                    "tcpUrgTotalCount", "nonEmptyPacketCount", "reverseNonEmptyPacketCount", 
                    "bytesPerPacket", "dataByteCount", "reverseDataByteCount", "firstNonEmptyPacketSize", 
                    "reverseFirstNonEmptyPacketSize", "maxPacketSize", "reverseMaxPacketSize", 
                    "standardDeviationPayloadLength", "reverseStandardDeviationPayloadLength", 
                    "standardDeviationInterarrivalTime", "reverseStandardDeviationInterarrivalTime", 
                    "reverseSmallPacketCount", "reverseNonEmptyPacketCount", "reverseBytesPerPacket", 
                    "reverseDataByteCount", "averageInterarrivalTime", "reverseAverageInterarrivalTime")
    
    dataset <- dataset %>%
        mutate(across(all_of(count_vars), ~replace_na(., 0)))
   
dataset <- dataset %>%
    mutate(
        http = ifelse(protocolIdentifier == 6 & (sourceTransportPort == 80 | destinationTransportPort == 80), 1, 0),
        https = ifelse(protocolIdentifier == 6 & (sourceTransportPort == 443 | destinationTransportPort == 443), 1, 0),
        dns = ifelse((protocolIdentifier == 17 & (sourceTransportPort == 53 | destinationTransportPort == 53)) | 
                         (protocolIdentifier == 6 & (sourceTransportPort == 53 | destinationTransportPort == 53)), 1, 0),
        ntp = ifelse(protocolIdentifier == 17 & (sourceTransportPort == 123 | destinationTransportPort == 123), 1, 0),
        tcp = ifelse(protocolIdentifier == 6 & http == 0 & https == 0 & dns == 0, 1, 0), 
        udp = ifelse(protocolIdentifier == 17 & dns == 0 & ntp == 0, 1, 0) 
    )    
    return(dataset)
}

# 2.Because when creating a remote IP address, we need to take control of the current device's IP address, so this code is not included in the processing function.

 Mac <- "70:26:05:73:6e:31" 
 qrio_hub1$sourceMacAddress <- gsub(":+$", "", qrio_hub1$sourceMacAddress)
qrio_hub1$destinationMacAddress <- gsub(":+$", "", qrio_hub1$destinationMacAddress)
 qrio_hub1$remote_ip <- ifelse(
     qrio_hub1$sourceMacAddress == mac, 
     qrio_hub1$destinationIPv4Address, 
     ifelse(qrio_hub1$destinationMacAddress == mac, 
            qrio_hub1$sourceIPv4Address, 
            NA)
)

