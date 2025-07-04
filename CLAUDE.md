# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Ruby on Rails Task Manager application. Currently, it appears to be in early development stages with minimal implementation.

## Technology Stack

- **Backend**: Ruby on Rails
- **Database**: SQLite (development and test environments)
- **Frontend**: TailwindCSS for styling
- **Development Tools**: Ruby LSP for language server support

## Project Structure

This Rails application follows standard Rails conventions:

- `app/` - Application code (currently minimal)
- `config/` - Configuration files (contains master.key for credentials)
- `storage/` - Database files (development.sqlite3, test.sqlite3)
- `log/` - Application logs
- `tmp/` - Temporary files and cache

## Development Setup

Since this appears to be a fresh Rails project, typical Rails setup would apply:

1. Install dependencies: `bundle install`
2. Setup database: `rails db:create db:migrate`
3. Start server: `rails server`
4. Run tests: `rails test`

## Frontend Assets

- TailwindCSS is configured and compiled CSS is in `app/assets/builds/tailwind.css`
- The project uses TailwindCSS v3.4.17 for styling

## Current State

This project appears to be in the initial setup phase with:
- Basic Rails directory structure
- TailwindCSS integration
- SQLite databases created
- Ruby LSP configuration for development

## GitHub Actions Code Review

When Claude is mentioned in a PR comment, perform thorough code review analysis focusing on:

### Security Review
- Check for SQL injection vulnerabilities in ActiveRecord queries
- Verify proper parameter sanitization and strong parameters usage
- Ensure no hardcoded secrets or API keys in code
- Validate authentication and authorization implementations
- Review file upload handling for security risks

### Rails Best Practices
- Verify proper use of Rails conventions (RESTful routes, naming)
- Check for N+1 query issues and database optimization
- Ensure proper error handling and logging
- Validate model associations and validations
- Review controller actions for proper responsibility separation

### Code Quality
- Check for DRY violations and code duplication
- Verify proper test coverage for new features
- Ensure consistent code style and formatting
- Review for potential performance bottlenecks
- Validate proper use of Rails helpers and concerns

### Database & Migration Review
- Check migration files for proper rollback procedures
- Verify database constraints and indexes
- Ensure proper foreign key relationships
- Review for potential data loss scenarios

### Frontend Integration
- Verify TailwindCSS classes are used consistently
- Check for proper CSRF token handling in forms
- Ensure responsive design implementation
- Review JavaScript/Turbo integration if present

### Testing Requirements
- Verify unit tests for models and services
- Check integration tests for controller actions
- Ensure proper test data setup and cleanup
- Review for edge case testing

## Development Notes

- The project uses SQLite for both development and test environments
- TailwindCSS is already configured and built
- Standard Rails MVC architecture should be followed as the application develops
- The application appears to be set up for a task management system based on the repository name