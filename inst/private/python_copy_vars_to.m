function s = python_copy_vars_to(in, varargin)

  s = '';

  if 1==0
  s = sprintf('%s%s = []\n\n', s, in);
  s = do_list(s, 0, in, varargin);
  else
  tag = ipc_misc_params();

  s = sprintf('%stry:\n', s);
  s = sprintf('%s    %s = []\n', s, in);
  s = do_list(s, 4, in, varargin);
  s = sprintf('%s    print "%s"\n', s, tag.block);
  s = sprintf('%s    print "%s\\n%s"\n', s, tag.item, tag.enditem);
  s = sprintf('%s    print "%s"\n', s, tag.item);
  s = sprintf('%s    print "PYTHON: successful variable import"\n', s);
  s = sprintf('%s    print "%s"\n', s, tag.enditem);
  s = sprintf('%s    print "%s"\n', s, tag.endblock);

  s = sprintf('%sexcept:\n', s);
  s = sprintf('%s    print\n', s);
  s = sprintf('%s    print "%s"\n', s, tag.block);
  s = sprintf('%s    print "%s\\n%s"\n', s, tag.item, tag.enditem);
  s = sprintf('%s    print "%s"\n', s, tag.item);
  s = sprintf('%s    print "PYTHON: Error in variable import"\n', s);
  s = sprintf('%s    print "%s"\n', s, tag.enditem);
  s = sprintf('%s    print "%s"\n', s, tag.endblock);
  s = sprintf('%s\n\n', s);
  %s = sprintf('%s    rethrow\n\n', s, tag.endblock);
  end
end


function s = do_list(s, indent, in, L)

  sp = char(' ' * ones(indent, 1));
  for i=1:numel(L)
    x = L{i};
    if (isa(x,'sym')) %&& isscalar(x))   % wrong for mat sympys
      s = sprintf('%s%s# Load %d: pickle\n', s, sp, i);
      % need to be careful here: pickle might have escape codes
      %s = sprintf('%s%s%s.append(pickle.loads("""%s"""))\n', s, sp, in, x.pickle);
      % subsref is a workaround: otherwise this calls size/numel,
      % starts a recursion if size not cached in the sym.
      idx.type = '.';
      idx.subs = 'pickle';
      %s = sprintf('%s%s%s.append(%s)\n', s, sp, in, x.pickle);
      s = sprintf('%s%s%s.append(%s)\n', s, sp, in, sprintf(subsref(x, idx)));
      % The extra printf around the pickle helps if it still has
      % escape codes (and seems harmless if it does not)
    elseif (ischar(x))
      s = sprintf('%s%s# Load %d: string\n', s, sp, i);
      s = sprintf('%s%s%s.append("%s")\n', s, sp, in, x);
    elseif (isnumeric(x) && isscalar(x))
      % TODO: should pass the actual double, see comments elsewhere
      % for this same problem in other direction
      s = sprintf('%s%s# Load %d: double\n', s, sp, i);
      s = sprintf('%s%s%s.append(%.24g)\n', s, sp, in, x);
    elseif (iscell(x))
      s = sprintf('%s%s# Load %d: a cell array to list\n', s, sp, i);
      inn = [in 'n'];
      s = sprintf('%s%s%s = []\n', s, sp, inn);
      s = sprintf('%s%s%s.append(%s)\n', s, sp, in, inn);
      s = do_list(s, indent, inn, x);
    else
      i, x
      error('don''t know how to move that variable to python');
    end
  end
  s = sprintf('%s%s# end of a list\n', s, sp);
end

