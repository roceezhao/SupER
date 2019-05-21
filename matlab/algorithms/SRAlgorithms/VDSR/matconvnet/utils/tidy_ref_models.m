function tidy_ref_models()
% Update reference models to latest MatConvNet version

run(fullfile(fileparts(mfilename('fullpath')), '..', 'matlab', 'vl_setupnn.m')) ;

models = {...
  'imagenet-resnet-152-dag', ...
  'imagenet-resnet-101-dag', ...
  'imagenet-resnet-50-dag', ...
  'imagenet-matconvnet-alex', ...
  'imagenet-matconvnet-vgg-f', ...
  'imagenet-matconvnet-vgg-m', ...
  'imagenet-matconvnet-vgg-m', ...
  'imagenet-matconvnet-vgg-s', ...
  'imagenet-matconvnet-vgg-verydeep-16', ...
  'imagenet-caffe-ref', ...
  'imagenet-caffe-alex', ...
  'imagenet-vgg-s', ...
  'imagenet-vgg-m', ...
  'imagenet-vgg-f', ...
  'imagenet-vgg-m-128', ...
  'imagenet-vgg-m-1024', ...
  'imagenet-vgg-m-2048', ...
  'imagenet-vgg-verydeep-19', ...
  'imagenet-vgg-verydeep-16', ...
  'imagenet-googlenet-dag', ...
  'pascal-fcn16s-dag', ...
  'pascal-fcn32s-dag', ...
  'pascal-fcn8s-dag', ...
  'pascal-fcn8s-tvg-dag', ...
  'vgg-face', ...
         }  ;

mkdir(fullfile('data', 'models')) ;

for i = 1:numel(models)
  inPath = fullfile('data', 'models-import', [models{i} '.mat']) ;
  outPath = fullfile('data', 'models', [models{i} '.mat']) ;
  if exist(outPath), continue ; end

  fprintf('%s: loading ''%s''\n', mfilename, inPath) ;
  net = load(inPath) ;
  % Cannot use isa('dagnn.DagNN') because it is not an object yet
  isDag = isfield(net, 'params') ;

  if isDag
    net = dagnn.DagNN.loadobj(net) ;
    net = net.saveobj() ;
  else
    net = vl_simplenn_tidy(net) ;
  end

  fprintf('%s: saving ''%s''\n', mfilename, outPath) ;
  save(fullfile('data', 'models', [models{i} '.mat']), '-struct', 'net') ;
end