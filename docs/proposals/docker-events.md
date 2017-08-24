Collect and store docker events
====
Docker events
===
Log messages accessible through docker daemon on the /events GET [endpoint](accessible through docker daemon on the /events GET endpoint). [Example](https://gist.github.com/josefkarasek/be9bac36921f7bc9a61df23451594fbf).
Why?
===
* Provide more information for docker daemon audit
* Correlate docker and kubelet actions
  * Real time analysis and alerting - send alerts if a not-allowed activity happens on the daemon


How?
===
Create a fluentd [input plugin](https://github.com/josefkarasek/fluent-plugin-docker-events/blob/master/lib/fluent/plugin/in_docker_events.rb), that listens on docker socket for incoming events and sends them to [Origin Aggregated Logging](https://github.com/openshift/origin-aggregated-logging) project.


FAQ
===
Q: Docker daemon logs are already being collected from systemd-journal, what is new here?
A: Daemon logs provide very brief information about the resource on which the activity happened. For container that means container ID, which will allow for further processing and correlation.
