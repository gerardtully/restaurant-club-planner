# 📚 Documentation

This directory contains all project documentation, organized by type and status.

## 📁 Structure

### `/prds/` - Product Requirements Documents
Where all PRDs (Product Requirements Documents) are stored and organized by lifecycle stage.

#### `/prds/current/`
- **Purpose**: Active PRD for the project currently being developed
- **File**: `PROJECT_PRD.md` - The main PRD template ready for your project details
- **Usage**: Fill out this template with your project requirements before starting development

#### `/prds/future/`
- **Purpose**: PRDs for features planned for future development
- **Naming**: Use descriptive names like `dark-mode-feature.md` or `v2-api-redesign.md`
- **Usage**: Store ideas and feature requests here to keep them organized

#### `/prds/completed/`
- **Purpose**: Archive of implemented PRDs for reference
- **Usage**: Move PRDs here after the feature is fully deployed
- **Benefits**: Track what's been built and reference past decisions

## 🚀 Workflow

1. **Start a new project**: Copy the PRD template to `/prds/current/PROJECT_PRD.md`
2. **Plan future work**: Add new PRDs to `/prds/future/`
3. **Complete projects**: Move finished PRDs to `/prds/completed/`

## 📝 PRD Best Practices

- Keep PRDs concise (1-2 pages)
- Focus on the "what" and "why", not the "how"
- Include clear success metrics
- Define scope boundaries explicitly
- Use the templates in `/templates/` as a starting point

## 🔗 Related Resources

- **PRD Template**: `/templates/PRD_TEMPLATE.md`
- **PRD Parsing**: `/templates/PRD_PARSING_PROMPT.md`
- **Examples**: `/examples/` directory for real PRD examples
- **Guide**: See `AI_DEVELOPMENT_GUIDE.md` for the complete PRD workflow