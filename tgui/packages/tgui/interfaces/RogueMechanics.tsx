import { useState } from 'react';
import {
  Box,
  Button,
  Collapsible,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
  TextArea,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Entry = {
  id: string;
  desc: string;
  text: string;
  default: string;
  inputs: string[];
  error: string | null;
  value: BooleanLike;
  group: string;
};

type Group = {
  id: string;
  name: string;
  entries: number;
};

type Prefix = {
  name: string;
  entries: number;
};

type Category = {
  name: string;
  file: string;
  desc: string;
  entries: number;
  fields: string[];
};

// The registry holds thousands of values. The window gets one page of one
// group at a time, and only when the admin acts: the backend keeps autoupdate
// off and narrows the list itself.
type Data = {
  // Static: sent when the window opens and after a reload.
  directory: string;
  export_directory: string;
  groups: Group[];
  categories: Category[];
  // Dynamic: the page the admin is looking at.
  loaded_ago: string;
  problems: string[];
  can_save: BooleanLike;
  group: string;
  prefix: string;
  search: string;
  changed_only: BooleanLike;
  page: number;
  pages: number;
  matched: number;
  prefixes: Prefix[];
  entries: Entry[];
};

const GROUP_ALL = 'all';

/** A value: one line with its number. */
const ValueRow = (props: { entry: Entry; showGroup: boolean }) => {
  const { act } = useBackend<Data>();
  const { entry, showGroup } = props;
  // null while the admin is not editing: the field then follows the text the
  // server holds (a reload, a reset, another admin's change).
  const [draft, setDraft] = useState<string | null>(null);
  const shown = draft ?? entry.text;
  const changed = entry.text !== entry.default;
  const apply = () => {
    act('set_formula', { id: entry.id, text: shown });
    setDraft(null);
  };
  return (
    <Box className="candystripe" p={0.5}>
      <Stack align="center">
        <Stack.Item grow basis={0} style={{ wordBreak: 'break-all' }}>
          <Box
            bold
            color={entry.error ? 'bad' : changed ? 'average' : undefined}
          >
            {entry.id}
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Input
            width="120px"
            monospace
            value={shown}
            onChange={setDraft}
            onEnter={apply}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="check"
            tooltip="Apply"
            disabled={shown === entry.text}
            onClick={apply}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="eraser"
            tooltip={`Default: ${entry.default}`}
            disabled={!changed}
            onClick={() => {
              setDraft(null);
              act('reset_formula', { id: entry.id });
            }}
          />
        </Stack.Item>
      </Stack>
      <Box color="label">
        {showGroup && `${entry.group}: `}
        {entry.desc}
      </Box>
      {!!entry.error && <NoticeBox danger>{entry.error}</NoticeBox>}
    </Box>
  );
};

/** A formula: its text, its inputs and a try-out. */
const FormulaEditor = (props: { entry: Entry }) => {
  const { act } = useBackend<Data>();
  const { entry } = props;
  // null while the admin is not editing, as in ValueRow.
  const [draft, setDraft] = useState<string | null>(null);
  const [values, setValues] = useState<Record<string, string>>({});
  const shown = draft ?? entry.text;
  const changed = entry.text !== entry.default;
  return (
    <Collapsible
      title={entry.id + (changed ? ' (changed)' : '')}
      color={entry.error ? 'bad' : changed ? 'average' : 'default'}
    >
      <Box color="label" mb={1}>
        {entry.desc}
      </Box>
      {!!entry.error && <NoticeBox danger>{entry.error}</NoticeBox>}
      <TextArea fluid height="70px" value={shown} onChange={setDraft} />
      <Stack mt={1} mb={1}>
        <Stack.Item>
          <Button
            icon="check"
            disabled={shown === entry.text}
            onClick={() => {
              act('set_formula', { id: entry.id, text: shown });
              setDraft(null);
            }}
          >
            Apply
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="undo"
            disabled={draft === null}
            onClick={() => setDraft(null)}
          >
            Revert edit
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="eraser"
            disabled={!changed}
            onClick={() => {
              setDraft(null);
              act('reset_formula', { id: entry.id });
            }}
          >
            Default
          </Button>
        </Stack.Item>
      </Stack>
      <Box color="label" mb={1}>
        Default: {entry.default}
      </Box>
      <LabeledList>
        {entry.inputs.map((input) => (
          <LabeledList.Item key={input} label={input}>
            <Input
              width="80px"
              value={values[input] || ''}
              onChange={(value) =>
                setValues((old) => ({ ...old, [input]: value }))
              }
            />
          </LabeledList.Item>
        ))}
      </LabeledList>
      <Button
        mt={1}
        icon="calculator"
        onClick={() => act('try_formula', { id: entry.id, values })}
      >
        Try with these inputs
      </Button>
    </Collapsible>
  );
};

/** The formulas, every value file and "Everything", with their sizes. */
const GroupList = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Stack vertical>
      {data.groups.map((group) => (
        <Stack.Item key={group.id}>
          <Button
            fluid
            selected={group.id === data.group}
            onClick={() => act('select_group', { id: group.id })}
          >
            {group.name}
            <Box as="span" color="label" ml={1}>
              {group.entries}
            </Box>
          </Button>
        </Stack.Item>
      ))}
    </Stack>
  );
};

/** Search, "changed only" and the prefixes of the group's ids. */
const Filters = () => {
  const { act, data } = useBackend<Data>();
  return (
    <>
      <Stack align="center" mb={1}>
        <Stack.Item grow>
          <Input
            fluid
            expensive
            placeholder="Search by name or description"
            value={data.search}
            onChange={(value) => act('set_search', { text: value })}
          />
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            checked={!!data.changed_only}
            onClick={() => act('toggle_changed')}
          >
            Changed only
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="sync"
            tooltip="Read the list again"
            onClick={() => act('refresh')}
          />
        </Stack.Item>
      </Stack>
      {data.prefixes.length > 1 && (
        <Box mb={1} style={{ maxHeight: '8em', overflowY: 'auto' }}>
          <Button
            selected={!data.prefix}
            onClick={() => act('set_prefix', { prefix: '' })}
          >
            all
          </Button>
          {data.prefixes.map((prefix) => (
            <Button
              key={prefix.name}
              selected={prefix.name === data.prefix}
              onClick={() => act('set_prefix', { prefix: prefix.name })}
            >
              {prefix.name}
              <Box as="span" color="label" ml={0.5}>
                {prefix.entries}
              </Box>
            </Button>
          ))}
        </Box>
      )}
    </>
  );
};

const Pager = () => {
  const { act, data } = useBackend<Data>();
  const { page, pages, matched } = data;
  return (
    <Stack align="center" mb={1}>
      <Stack.Item>
        <Button
          icon="angle-double-left"
          disabled={page <= 1}
          onClick={() => act('set_page', { page: 1 })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="angle-left"
          disabled={page <= 1}
          onClick={() => act('set_page', { page: page - 1 })}
        />
      </Stack.Item>
      <Stack.Item>
        Page {page} of {pages}
        <Box as="span" color="label" ml={1}>
          {matched} entries
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="angle-right"
          disabled={page >= pages}
          onClick={() => act('set_page', { page: page + 1 })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="angle-double-right"
          disabled={page >= pages}
          onClick={() => act('set_page', { page: pages })}
        />
      </Stack.Item>
    </Stack>
  );
};

const ConfigSection = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Section
      title="Config"
      buttons={
        <>
          <Button icon="sync" onClick={() => act('reload')}>
            Reload configs
          </Button>
          <Button icon="file-export" onClick={() => act('export')}>
            Export values
          </Button>
          <Button icon="shield-alt" onClick={() => act('armor_compare')}>
            Armor comparison
          </Button>
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Read from">{data.directory}</LabeledList.Item>
        <LabeledList.Item label="Loaded">
          {data.loaded_ago} ago
        </LabeledList.Item>
        <LabeledList.Item label="Export to">
          {data.export_directory}
        </LabeledList.Item>
      </LabeledList>
      {data.problems.length > 0 && (
        <NoticeBox danger mt={1}>
          {data.problems.map((problem) => (
            <Box key={problem}>{problem}</Box>
          ))}
        </NoticeBox>
      )}
      <Collapsible title="Tables" mt={1}>
        <Table>
          <Table.Row header>
            <Table.Cell>Table</Table.Cell>
            <Table.Cell>File</Table.Cell>
            <Table.Cell collapsing>Entries</Table.Cell>
            <Table.Cell>Fields</Table.Cell>
          </Table.Row>
          {data.categories.map((category) => (
            <Table.Row key={category.name} className="candystripe">
              <Table.Cell>{category.name}</Table.Cell>
              <Table.Cell>{category.file}</Table.Cell>
              <Table.Cell>{category.entries}</Table.Cell>
              <Table.Cell color="label">
                {category.fields.join(', ')}
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Collapsible>
    </Section>
  );
};

export const RogueMechanics = () => {
  const { act, data } = useBackend<Data>();
  const everything = data.group === GROUP_ALL;
  return (
    <Window width={940} height={760}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <ConfigSection />
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item basis="180px" shrink={0}>
                <Section fill scrollable title="Groups">
                  <GroupList />
                </Section>
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <Section
                  fill
                  scrollable
                  title="Formulas and values"
                  buttons={
                    !!data.can_save && (
                      <Button icon="save" onClick={() => act('save_formulas')}>
                        Save to config
                      </Button>
                    )
                  }
                >
                  <Box color="label" mb={1}>
                    Applied formulas and values change the live game until the
                    next reload or restart. Save writes them to the config
                    files.
                  </Box>
                  <Filters />
                  <Pager />
                  {data.entries.map((entry) =>
                    entry.value ? (
                      <ValueRow
                        key={entry.id}
                        entry={entry}
                        showGroup={everything}
                      />
                    ) : (
                      <FormulaEditor key={entry.id} entry={entry} />
                    ),
                  )}
                  {data.entries.length === 0 && (
                    <NoticeBox>Nothing matches.</NoticeBox>
                  )}
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
