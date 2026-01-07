#!/bin/sh

# Colors for nicer output
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

# Helper function to run a test
run_test() {
    DESC="$1"
    URL="$2"
    CERT="$3"
    KEY="$4"

    echo "${YELLOW}==> $DESC${RESET}"

    # Run curl silently, capture status code and output
    if [ -n "$CERT" ] && [ -n "$KEY" ]; then
        RESPONSE=$(curl -k -s -w "%{http_code}" --cert "$CERT" --key "$KEY" "$URL")
    else
        RESPONSE=$(curl -k -s -w "%{http_code}" "$URL")
    fi

    # Separate HTTP body and status code
    HTTP_BODY=$(echo "$RESPONSE" | sed '$ s/[0-9]\{3\}$//')
    HTTP_CODE=$(echo "$RESPONSE" | tail -c 4 | tr -d '\n')

    # Color code based on status
    if [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 300 ]; then
        COLOR=$GREEN
        STATUS="SUCCESS"
    else
        COLOR=$RED
        STATUS="FAILURE"
    fi

    echo "${COLOR}HTTP $HTTP_CODE - $STATUS${RESET}"
    echo "$HTTP_BODY"
    echo "----------------------------------------"
}

# Define test cases
run_test "Unprotected route / (no failure expected)" "https://localhost:8443/"
run_test "Protected route /admin with valid cert (expect 200)" "https://localhost:8443/admin" "certs/client.crt" "certs/client.key"
run_test "Protected route /admin (no cert, expect 403)" "https://localhost:8443/admin"
run_test "Protected route /admin with invalid cert (expect 403)" "https://localhost:8443/admin" "certs/bad_client.crt" "certs/bad_client.key"
