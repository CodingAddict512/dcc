enum Status {
  DRAFT,
  ASSIGNED,
  STARTED,
  SUBMITTED,
  /* Only set by the backend (SUBMITTED -> {COLLECTED,REJECTED}) */
  COLLECTED,
  /* Only set by the backend (SUBMITTED -> {COLLECTED,REJECTED}) */
  REJECTED,
}
