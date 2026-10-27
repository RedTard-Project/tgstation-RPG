// Vibelin's Gameplay page: the class and roles (its JobPreferences window, folded into the page: departments, search,
// a priority per role, and in place of Vibelin's alternate titles the subclasses a Rockhill role picks from), the
// triumphs and the loadout, which stays in TG's menu. Vibelin's ready order, special roles, triumph shop and donor
// loadout have no system here.
import { Fragment, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Input, Section, Table, Tabs } from 'tgui-core/components';

import { ActionButton, InfoRow, Panel } from './components';
import { type JobEntry, JobPriority, type SetupData } from './types';

const PRIORITIES = [
  { value: JobPriority.High, label: 'High' },
  { value: JobPriority.Medium, label: 'Medium' },
  { value: JobPriority.Low, label: 'Low' },
  { value: null, label: 'Never' },
] as const;

/** The role the player wants most, as Vibelin's footer and class row show it. */
export function highestJob(prefs: SetupData['job_preferences']) {
  let best: string | null = null;
  let bestLevel = 0;
  for (const [title, level] of Object.entries(prefs ?? {})) {
    if (typeof level === 'number' && level > bestLevel) {
      best = title;
      bestLevel = level;
    }
  }
  return best;
}

export function GameplayPage() {
  const { act, data } = useBackend<SetupData>();
  return (
    <>
      <Panel title="Class & Roles" icon="shield-alt">
        <InfoRow
          icon="briefcase"
          label="Wanted most"
          value={highestJob(data.job_preferences) ?? 'None'}
        />
        <JobList />
      </Panel>
      <Panel title="Loadout" icon="shopping-bag">
        <Box color="label" mb={0.5}>
          The loadout (the wardrobe of Vibelin's clothes among it) and quirks
          are kept in TG's preferences.
        </Box>
        <ActionButton
          icon="tshirt"
          label="Open Loadout & Quirks"
          onClick={() => act('open_tg', { page: 'character' })}
        />
      </Panel>
      <Panel title="Triumphs" icon="trophy">
        <InfoRow icon="coins" label="Balance" value={data.triumphs} />
      </Panel>
    </>
  );
}

function JobList() {
  const { act, data } = useBackend<SetupData>();
  const departments = [...data.jobs].sort(
    (left, right) => left.order - right.order,
  );
  const [activeName, setActiveName] = useState(departments[0]?.name);
  const [expanded, setExpanded] = useState<string | null>(null);
  const [search, setSearch] = useState('');

  const colors: Record<string, string | null> = {};
  for (const department of departments) {
    for (const job of department.jobs) {
      colors[job.title] = department.color;
    }
  }
  const needle = search.trim().toLowerCase();
  const active =
    departments.find((department) => department.name === activeName) ??
    departments[0];
  const jobs: JobEntry[] = needle
    ? departments.flatMap((department) =>
        department.jobs.filter((job) =>
          [job.title, ...job.classes.map((entry) => entry.name)]
            .join(' ')
            .toLowerCase()
            .includes(needle),
        ),
      )
    : (active?.jobs ?? []);

  if (!departments.length) {
    return <Box color="label">The roles are not ready yet.</Box>;
  }

  return (
    <>
      <Input
        fluid
        mb={0.5}
        placeholder="Search roles..."
        value={search}
        onChange={setSearch}
      />
      <Tabs>
        {departments.map((department) => {
          const selected = !needle && department.name === active?.name;
          return (
            <Tabs.Tab
              key={department.name}
              selected={selected}
              onClick={() => {
                setActiveName(department.name);
                setExpanded(null);
                setSearch('');
              }}
              style={{
                borderBottom: `2px solid ${selected ? department.color || 'white' : 'transparent'}`,
              }}
            >
              <Box
                style={{ color: department.color || undefined }}
                bold={selected}
              >
                {department.name}
              </Box>
            </Tabs.Tab>
          );
        })}
      </Tabs>
      <Section
        title={needle ? `Search Results (${jobs.length})` : active?.name}
      >
        <Table>
          <Table.Row header>
            <Table.Cell width="40%">Role</Table.Cell>
            <Table.Cell width="20%">Classes</Table.Cell>
            <Table.Cell width="40%">Priority</Table.Cell>
          </Table.Row>
          {!jobs.length && (
            <Table.Row>
              <Table.Cell colSpan={3}>
                <Box color="label" italic>
                  No roles match.
                </Box>
              </Table.Cell>
            </Table.Row>
          )}
          {jobs.map((job) => {
            const banned = data.job_bans.includes(job.title);
            const level = data.job_preferences?.[job.title] ?? null;
            const isExpanded = expanded === job.title;
            return (
              <Fragment key={job.title}>
                <Table.Row>
                  <Table.Cell
                    py={0.5}
                    style={{
                      borderLeft: `3px solid ${colors[job.title] || 'transparent'}`,
                      paddingLeft: '6px',
                    }}
                  >
                    <Button
                      color="transparent"
                      bold={!!level}
                      tooltip={job.description || undefined}
                    >
                      {job.title}
                    </Button>
                    <Box
                      color={banned ? 'bad' : 'label'}
                      style={{ fontSize: '11px' }}
                    >
                      {banned
                        ? 'BANNED'
                        : job.slots > 0
                          ? `${job.slots} slot${job.slots === 1 ? '' : 's'}`
                          : 'Any number'}
                    </Box>
                  </Table.Cell>
                  <Table.Cell py={0.5}>
                    {job.classes.length > 0 && (
                      <Button
                        icon="info-circle"
                        selected={isExpanded}
                        onClick={() =>
                          setExpanded(isExpanded ? null : job.title)
                        }
                      >
                        {job.classes.length}
                      </Button>
                    )}
                  </Table.Cell>
                  <Table.Cell py={0.5}>
                    {!banned &&
                      PRIORITIES.map((option) => (
                        <Button
                          key={option.label}
                          color={
                            level === option.value ? 'good' : 'transparent'
                          }
                          selected={level === option.value}
                          onClick={() =>
                            act('set_job_preference', {
                              job: job.title,
                              level: option.value,
                            })
                          }
                        >
                          {option.label}
                        </Button>
                      ))}
                  </Table.Cell>
                </Table.Row>
                {isExpanded && (
                  <Table.Row>
                    <Table.Cell
                      colSpan={3}
                      style={{
                        backgroundColor: 'rgba(0,0,0,0.15)',
                        padding: '8px',
                      }}
                    >
                      {job.classes.map((entry) => (
                        <Box key={entry.name} mb={0.5}>
                          <Box bold>{entry.name}</Box>
                          {!!entry.desc && (
                            <Box color="label">{entry.desc}</Box>
                          )}
                        </Box>
                      ))}
                    </Table.Cell>
                  </Table.Row>
                )}
              </Fragment>
            );
          })}
        </Table>
      </Section>
    </>
  );
}
