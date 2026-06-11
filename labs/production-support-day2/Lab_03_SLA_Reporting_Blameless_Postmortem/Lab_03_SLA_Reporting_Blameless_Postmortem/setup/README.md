# Lab 3 — Setup Files

Optional helper files for Steps 3 and 4. Copy to the EC2 instance with `scp` — see [instructions.md](../instructions.md).

| File | Use |
|------|-----|
| `cloudwatch_agent_config.json` | CloudWatch agent configuration |
| `send_metrics.sh` | Custom metrics script (ServiceHealth, ResponseTimeMs) |
| `build_lab3_workbooks.py` | Regenerate `template/lab3_starter.xlsx` and `instructor/lab3_solution.xlsx` |

**Region:** `ca-central-1`

```bash
python setup/build_lab3_workbooks.py
```
