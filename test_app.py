#!/usr/bin/env python3
"""
Test script for File Extractor Application
Creates sample .ts and .env files in a test directory structure
"""

import os
import tempfile
from pathlib import Path

def create_test_files():
    """Create a test directory structure with sample .ts and .env files"""
    
    # Create temporary test directory
    test_dir = Path(tempfile.mkdtemp(prefix="file_extractor_test_"))
    print(f"Creating test files in: {test_dir}")
    
    # Create sample .py files
    py_files = [
        "main.py",
        "utils.py",
        "config.py",
        "src/components/button.py",
        "src/components/input.py",
        "src/utils/helpers.py",
        "src/types/index.py",
        "tests/unit/utils_test.py",
        "tests/integration/api_test.py"
    ]
    
    # Create sample other file types
    other_files = [
        "package.json",
        "tsconfig.json",
        "docker-compose.yml",
        "config.yaml",
        "src/components/App.tsx",
        "src/types/types.ts",
        "Dockerfile",
        "src/config/settings.yml"
    ]
    
    # Create sample .env files
    env_files = [
        ".env",
        ".env.local",
        ".env.production",
        "config/.env.dev",
        "config/.env.staging"
    ]
    
    # Create directories and files
    for file_path in py_files + other_files + env_files:
        full_path = test_dir / file_path
        full_path.parent.mkdir(parents=True, exist_ok=True)
        
        if file_path.endswith('.py'):
            # Create sample Python content
            content = f"""# Sample Python file: {file_path}
from typing import Dict, Any

class Config:
    def __init__(self, name: str, version: str):
        self.name = name
        self.version = version

config = Config("Test App", "1.0.0")

def get_config() -> Config:
    return config
"""
        elif file_path.endswith('.json'):
            # Create sample JSON content
            content = f"""{{
  "name": "test-app",
  "version": "1.0.0",
  "description": "Sample {file_path}",
  "main": "index.js",
  "scripts": {{
    "start": "node index.js",
    "test": "jest"
  }}
}}"""
        elif file_path.endswith(('.yml', '.yaml')):
            # Create sample YAML content
            content = f"""# Sample YAML file: {file_path}
app:
  name: TestApp
  version: 1.0.0
  debug: true
  database:
    host: localhost
    port: 5432
    name: testdb
"""
        elif file_path.endswith('.tsx'):
            # Create sample TSX content
            content = f"""// Sample TSX file: {file_path}
import React from 'react';

interface Props {{
  title: string;
  children: React.ReactNode;
}}

export const Component: React.FC<Props> = ({{ title, children }}) => {{
  return (
    <div className="component">
      <h1>{{title}}</h1>
      {{children}}
    </div>
  );
}};
"""
        elif file_path.endswith('.ts'):
            # Create sample TypeScript content
            content = f"""// Sample TypeScript file: {file_path}
export interface Config {{
  name: string;
  version: string;
  debug: boolean;
}}

export const config: Config = {{
  name: "Test App",
  version: "1.0.0",
  debug: true
}};
"""
        elif file_path == 'Dockerfile':
            # Create sample Dockerfile content
            content = f"""# Sample Dockerfile: {file_path}
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
"""
        else:
            # Create sample environment content
            content = f"""# Sample environment file: {file_path}
APP_NAME=TestApp
APP_VERSION=1.0.0
DEBUG=true
API_URL=https://api.example.com
"""
        
        full_path.write_text(content, encoding='utf-8')
        print(f"Created: {file_path}")
    
    print(f"\nTest directory created successfully!")
    print(f"Total files created: {len(py_files) + len(other_files) + len(env_files)}")
    print(f"Python files: {len(py_files)}")
    print(f"Other files (.json, .yml, .tsx, .ts, Dockerfile): {len(other_files)}")
    print(f"Environment files: {len(env_files)}")
    print(f"\nYou can now use this directory as the source in the File Extractor application.")
    print(f"Test directory: {test_dir}")
    
    return test_dir

if __name__ == "__main__":
    try:
        test_dir = create_test_files()
        print(f"\nTest completed successfully!")
        print(f"Test files are located in: {test_dir}")
        print(f"Use this path as the source directory in the File Extractor application.")
    except Exception as e:
        print(f"Error creating test files: {e}")
        import traceback
traceback.print_exc()
