#!/bin/bash

echo "Testing connections to all nodes..."
echo "=================================="

echo ""
echo "1. Testing Linux nodes..."
ansible linux -i inventory -m ping

echo ""
echo "2. Testing macOS nodes..."
ansible macOS -i inventory -m ping

echo ""
echo "3. Testing Windows nodes..."
ansible windows -i inventory -m win_ping

echo ""
echo "Connection tests completed!" 