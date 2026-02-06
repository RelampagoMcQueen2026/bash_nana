#!/bin/bash

LOG_DIR="/Users/kiwi_mac/Desktop/bash_nana"
APP_LOG_FILE="application.log"
SYS_LOG_FILE="system.log"

REPORT_FILE="/Users/kiwi_mac/Desktop/bash_nana/log_analysis_report.txt"

ERROR_PATTERNS=("ERROR" "FATAL" "CRITICAL")

LOG_FILES=$(find $LOG_DIR -name "*.log" -mtime -10)
echo $LOG_FILES

echo "Analysing log files" > "$REPORT_FILE"
echo "===================" >> "$REPORT_FILE"

for LOG_FILE in $LOG_FILES; do

    for PATTERN in ${ERROR_PATTERNS[@]}; do
        echo -e "\nSearching $PATTERN logs in $LOG_FILE file" >> "$REPORT_FILE"
        grep "$PATTERN" "$LOG_FILE" >> "$REPORT_FILE"

        echo -e "\nNumber of $PATTERN logs found in $LOG_FILE file" >> "$REPORT_FILE"
        grep -c "$PATTERN" "$LOG_FILE" >> "$REPORT_FILE"

        ERROR_COUNT=$(grep -c "$PATTERN" "$LOG_FILE")
        if [ "$ERROR_COUNT" -gt 10 ]; then
            echo "!!! Action Required !!! $PATTERN -gr 10 in $LOG_FILE"
        fi
    done

done

echo -e "\nLog analysis completed !! Report saved in: $REPORT_FILE"
