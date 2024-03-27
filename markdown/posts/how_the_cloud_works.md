---
title: How can we divide the Cloud
date: 2024-04-27
---

Web applications are normally divided into front-end and back-end. But for Software as a Service that division is not useful. The “back-end” is made of different software that has specific roles. From my experience working at AWS (on the Redshift team) and at Huawei Cloud, the most common division is:

1. **Management Plane**: Management Plane is normally written by SREs, and it is the software responsible for enabling interventions on production (manual or automated operations). Upgrading the system, rollbacks, failover and so on. It does not need to be up 99.9999% of the time, no user should be impacted if the whole plane is down, but every action should be extremely safe to do. One SRE during oncall should not be able to take down a whole service by using the Management Plane. I would also add the monitoring system: metrics ingestion, alarms and dashboards.
2. **Control Plane**: The Control Plane allow **users** to manage their service, we can include here: the public API, workflow systems (to execute user's commands, and background workflows to maintain the service) and auto-recovery actions (scaling up, removing bad hosts, restarting the service). Kubernetes can be the Control Plane of your service. If the Control Plane is down, the Data Plane should still work, but users are affected in the sense they cannot use the public API (e.g. EC2 instances should keep running, but it would be impossible to create new instances). We should aim for nine nines of availability.
3. **Data Plane**: The Data Plane is what your software as a service is. So if we are talking about AWS Redshift it would be the Database itself. If we are using Kubernetes, this would be the worker nodes.

Note: Some teams may merge the Management Plane and the Control Plane, for example, the Redshift Team had a team owning the Control Plane and another the Data Plane. Management Plane was mostly inside the Control Plane.
