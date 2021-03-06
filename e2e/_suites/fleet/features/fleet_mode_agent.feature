@fleet_mode
Feature: Fleet Mode Agent
  Scenarios for the Agent in Fleet mode connecting to Fleet application.

@enroll
Scenario Outline: Deploying the <os> agent
  When a "<os>" agent is deployed to Fleet with "<installer>" installer
  Then the "elastic-agent" process is in the "started" state on the host
    And the "filebeat" process is in the "started" state on the host
    And the "metricbeat" process is in the "started" state on the host
    And the agent is listed in Fleet as "online"
    And system package dashboards are listed in Fleet
Examples:
| os     | installer |
| centos | tar       |
| debian | tar       |

@stop-agent
Scenario Outline: Stopping the <os> agent stops backend processes
  Given a "<os>" agent is deployed to Fleet with "<installer>" installer
  When the "elastic-agent" process is "stopped" on the host
  Then the "filebeat" process is in the "stopped" state on the host
    And the "metricbeat" process is in the "stopped" state on the host
Examples:
| os     | installer |
| centos | tar       |
| debian | tar       |

@restart-agent
Scenario Outline: Restarting the installed <os> agent
  Given a "<os>" agent is deployed to Fleet with "<installer>" installer
  When the "elastic-agent" process is "restarted" on the host
    And the "filebeat" process is in the "started" state on the host
    And the "metricbeat" process is in the "started" state on the host
    And the agent is listed in Fleet as "online"
Examples:
| os     | installer |
| centos | tar       |
| debian | tar       |

@restart-host
Scenario Outline: Restarting the <os> host with persistent agent restarts backend processes
  Given a "<os>" agent is deployed to Fleet with "<installer>" installer
  When the host is restarted
  Then the "elastic-agent" process is in the "started" state on the host
    And the "filebeat" process is in the "started" state on the host
    And the "metricbeat" process is in the "started" state on the host
Examples:
| os     | installer |
| centos | tar       |
| debian | tar       |

@unenroll
Scenario Outline: Un-enrolling the <os> agent
  Given a "<os>" agent is deployed to Fleet with "<installer>" installer
  When the agent is un-enrolled
  Then the "elastic-agent" process is in the "started" state on the host
    And the agent is listed in Fleet as "inactive"
    And the "filebeat" process is in the "stopped" state on the host
    And the "metricbeat" process is in the "stopped" state on the host
Examples:
| os     | installer |
| centos | tar       |
| debian | tar       |

@reenroll
Scenario Outline: Re-enrolling the <os> agent
  Given a "<os>" agent is deployed to Fleet with "<installer>" installer
    And the agent is un-enrolled
    And the "elastic-agent" process is "stopped" on the host
  When the agent is re-enrolled on the host
    And the "elastic-agent" process is "started" on the host
  Then the agent is listed in Fleet as "online"
Examples:
| os     | installer |
| centos | tar       |
| debian | tar       |

@revoke-token
Scenario Outline: Revoking the enrollment token for the <os> agent
  Given a "<os>" agent is deployed to Fleet with "<installer>" installer
  When the enrollment token is revoked
  Then an attempt to enroll a new agent fails
Examples:
| os     | installer |
| centos | tar       |
| debian | tar       |

@uninstall-host
Scenario Outline: Un-installing the installed <os> agent
  Given a "<os>" agent is deployed to Fleet with "<installer>" installer
  When the "elastic-agent" process is "uninstalled" on the host
  Then the "elastic-agent" process is in the "stopped" state on the host
    And the "filebeat" process is in the "stopped" state on the host
    And the "metricbeat" process is in the "stopped" state on the host
    And the file system Agent folder is empty
    And the agent is listed in Fleet as "offline"
Examples:
| os     | installer |
| centos | tar       |
| debian | tar       |
