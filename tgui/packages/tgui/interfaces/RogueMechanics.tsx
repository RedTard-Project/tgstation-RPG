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

type Formula = {
  id: string;
  desc: string;
  text: string;
  default: string;
  inputs: string[];
  error: string | null;
};

type Category = {
  name: string;
  file: string;
  desc: string;
  entries: number;
  fields: string[];
};

type Data = {
  directory: string;
  export_directory: string;
  loaded_ago: string;
  problems: string[];
  formulas: Formula[];
  categories: Category[];
  can_save: BooleanLike;
};

const FormulaEditor = (props: { formula: Formula }) => {
  const { act } = useBackend<Data>();
  const { formula } = props;
  const [draft, setDraft] = useState(formula.text);
  const [values, setValues] = useState<Record<string, string>>({});
  const changed = formula.text !== formula.default;
  return (
    <Collapsible
      title={formula.id + (changed ? ' (changed)' : '')}
      color={formula.error ? 'bad' : changed ? 'average' : 'default'}
    >
      <Box color="label" mb={1}>
        {formula.desc}
      </Box>
      {formula.error && <NoticeBox danger>{formula.error}</NoticeBox>}
      <TextArea fluid height="70px" value={draft} onChange={setDraft} />
      <Stack mt={1} mb={1}>
        <Stack.Item>
          <Button
            icon="check"
            disabled={draft === formula.text}
            onClick={() => act('set_formula', { id: formula.id, text: draft })}
          >
            Apply
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button icon="undo" onClick={() => setDraft(formula.text)}>
            Revert edit
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="eraser"
            disabled={!changed}
            onClick={() => {
              setDraft(formula.default);
              act('reset_formula', { id: formula.id });
            }}
          >
            Default
          </Button>
        </Stack.Item>
      </Stack>
      <Box color="label" mb={1}>
        Default: {formula.default}
      </Box>
      <LabeledList>
        {formula.inputs.map((input) => (
          <LabeledList.Item key={input} label={input}>
            <Input
              width="80px"
              value={values[input] || ''}
              onChange={(value) => setValues({ ...values, [input]: value })}
            />
          </LabeledList.Item>
        ))}
      </LabeledList>
      <Button
        mt={1}
        icon="calculator"
        onClick={() => act('try_formula', { id: formula.id, values })}
      >
        Try with these inputs
      </Button>
    </Collapsible>
  );
};

export const RogueMechanics = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Window width={760} height={720}>
      <Window.Content scrollable>
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
            <LabeledList.Item label="Loaded">{data.loaded_ago} ago</LabeledList.Item>
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
        </Section>
        <Section title="Tables">
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
                <Table.Cell color="label">{category.fields.join(', ')}</Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
        <Section
          title="Formulas"
          buttons={
            !!data.can_save && (
              <Button icon="save" onClick={() => act('save_formulas')}>
                Save to config
              </Button>
            )
          }
        >
          <Box color="label" mb={1}>
            Applied formulas change the live game until the next reload or
            restart. Save writes them to the config file.
          </Box>
          {data.formulas.map((formula) => (
            <FormulaEditor key={formula.id + formula.text} formula={formula} />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
