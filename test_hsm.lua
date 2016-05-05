require 'torch'
require 'fbcunn'

hidden_dim = 10
input_dim = 20
batch_size = 1

gpuid = 0

function to_cuda(x) return gpuid >= 0 and x:cuda() or x end

inputs = to_cuda(torch.rand(batch_size, input_dim))
targets = to_cuda(torch.ones(batch_size):long())

-- #mapping should equal the number of possible outputs, in our case 8
-- this mapping defines 4 clusters, two size 2, one size 3, one size 1
mapping = { {1, 1}, {1, 2}, {2, 1}, {2, 2}, {2, 3}, {3, 1}, {4, 1}, {4, 2} }
linear = to_cuda(nn.Sequential():add(nn.Linear(input_dim,hidden_dim)))
--linear = to_cuda(nn.Sequential():add(nn.TemporalConvolution(input_dim,hidden_dim, 1)))
hsm = to_cuda(nn.HSM(mapping, hidden_dim))

h_out = linear:forward(inputs)
s_out, err = hsm:forward(h_out, targets)
df_ds = hsm:backward(h_out, targets)
linear:backward(inputs, df_ds)

