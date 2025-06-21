#!/usr/bin/env python3

import boto3
import base64
from cryptography.hazmat.primitives import serialization, hashes
from cryptography.hazmat.primitives.asymmetric import padding
import json

def get_windows_password():
    instance_id = "i-0efd44f4d9230e85a"
    private_key_path = "terraform/web-server-key"
    
    # Initialize EC2 client
    ec2 = boto3.client('ec2')
    
    print("Getting password data from AWS...")
    
    # Get password data
    response = ec2.get_password_data(InstanceId=instance_id)
    encrypted_password = response.get('PasswordData', '')
    
    if not encrypted_password:
        print("Password not ready yet. Windows is still initializing.")
        print("Try again in 5-10 minutes.")
        return None
    
    print("Encrypted password found! Decrypting...")
    
    # Read private key
    with open(private_key_path, 'rb') as key_file:
        private_key = serialization.load_pem_private_key(
            key_file.read(),
            password=None
        )
    
    # Decode and decrypt
    encrypted_data = base64.b64decode(encrypted_password)
    decrypted_password = private_key.decrypt(
        encrypted_data,
        padding.PKCS1v15()
    )
    
    password = decrypted_password.decode('utf-8')
    print(f"Administrator Password: {password}")
    
    return password

if __name__ == "__main__":
    try:
        password = get_windows_password()
        if password:
            print(f"\nUpdate ansible/inventory.yml:")
            print(f"Replace '{{ windows_password }}' with: {password}")
    except Exception as e:
        print(f"Error: {e}")
        print("Make sure you have boto3 and cryptography installed:")
        print("pip install boto3 cryptography")