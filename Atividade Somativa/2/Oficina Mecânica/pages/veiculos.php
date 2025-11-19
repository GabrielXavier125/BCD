<?php
// CRUD de veículos

// Buscar clientes para o select
$clientes = $pdo->query("SELECT id_cliente, nome FROM clientes ORDER BY nome")->fetchAll();

// CREATE / UPDATE
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id         = $_POST['id_veiculo'] ?? '';
    $id_cliente = (int)($_POST['id_cliente'] ?? 0);
    $placa      = trim($_POST['placa'] ?? '');
    $modelo     = trim($_POST['modelo'] ?? '');
    $ano        = $_POST['ano'] !== '' ? (int)$_POST['ano'] : null;
    $cor        = trim($_POST['cor'] ?? '');

    if ($id_cliente && $placa !== '' && $modelo !== '') {
        if ($id) {
            $stmt = $pdo->prepare("UPDATE veiculos
                                   SET id_cliente=?, placa=?, modelo=?, ano=?, cor=?
                                   WHERE id_veiculo=?");
            $stmt->execute([$id_cliente, $placa, $modelo, $ano, $cor, $id]);
        } else {
            $stmt = $pdo->prepare("INSERT INTO veiculos (id_cliente, placa, modelo, ano, cor)
                                   VALUES (?, ?, ?, ?, ?)");
            $stmt->execute([$id_cliente, $placa, $modelo, $ano, $cor]);
        }
    }
    header("Location: index.php?page=veiculos");
    exit;
}

// DELETE
if (isset($_GET['delete'])) {
    $id = (int)$_GET['delete'];
    $pdo->prepare("DELETE FROM veiculos WHERE id_veiculo = ?")->execute([$id]);
    header("Location: index.php?page=veiculos");
    exit;
}

// EDIT
$veiculoEdicao = null;
if (isset($_GET['edit'])) {
    $id = (int)$_GET['edit'];
    $stmt = $pdo->prepare("SELECT * FROM veiculos WHERE id_veiculo = ?");
    $stmt->execute([$id]);
    $veiculoEdicao = $stmt->fetch();
}

// LISTA
$sql = "SELECT v.*, c.nome AS nome_cliente
        FROM veiculos v
        JOIN clientes c ON c.id_cliente = v.id_cliente
        ORDER BY c.nome, v.placa";
$veiculos = $pdo->query($sql)->fetchAll();
?>
<div class="section-header">
  <h2>Veículos</h2>
</div>

<div class="grid-2">
  <div class="card form-card">
    <h3><?php echo $veiculoEdicao ? 'Editar Veículo' : 'Novo Veículo'; ?></h3>
    <form method="post">
      <input type="hidden" name="id_veiculo" value="<?php echo $veiculoEdicao['id_veiculo'] ?? ''; ?>">
      <div class="form-group">
        <label>Cliente</label>
        <select name="id_cliente" required>
          <option value="">Selecione...</option>
          <?php foreach ($clientes as $c): ?>
            <option value="<?php echo $c['id_cliente']; ?>"
              <?php
                $sel = $veiculoEdicao && $veiculoEdicao['id_cliente'] == $c['id_cliente'];
                echo $sel ? 'selected' : '';
              ?>>
              <?php echo htmlspecialchars($c['nome']); ?>
            </option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="form-group">
        <label>Placa</label>
        <input type="text" name="placa" required
               value="<?php echo htmlspecialchars($veiculoEdicao['placa'] ?? ''); ?>">
      </div>
      <div class="form-group">
        <label>Modelo</label>
        <input type="text" name="modelo" required
               value="<?php echo htmlspecialchars($veiculoEdicao['modelo'] ?? ''); ?>">
      </div>
      <div class="form-group">
        <label>Ano</label>
        <input type="number" name="ano"
               value="<?php echo htmlspecialchars($veiculoEdicao['ano'] ?? ''); ?>">
      </div>
      <div class="form-group">
        <label>Cor</label>
        <input type="text" name="cor"
               value="<?php echo htmlspecialchars($veiculoEdicao['cor'] ?? ''); ?>">
      </div>
      <button type="submit" class="btn primary">
        <?php echo $veiculoEdicao ? 'Atualizar' : 'Salvar'; ?>
      </button>
      <?php if ($veiculoEdicao): ?>
        <a href="index.php?page=veiculos" class="btn secondary">Cancelar</a>
      <?php endif; ?>
    </form>
  </div>

  <div class="card">
    <h3>Lista de Veículos</h3>
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Cliente</th>
            <th>Placa</th>
            <th>Modelo</th>
            <th>Ano</th>
            <th>Cor</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($veiculos as $v): ?>
            <tr>
              <td><?php echo $v['id_veiculo']; ?></td>
              <td><?php echo htmlspecialchars($v['nome_cliente']); ?></td>
              <td><?php echo htmlspecialchars($v['placa']); ?></td>
              <td><?php echo htmlspecialchars($v['modelo']); ?></td>
              <td><?php echo htmlspecialchars($v['ano']); ?></td>
              <td><?php echo htmlspecialchars($v['cor']); ?></td>
              <td>
                <a class="btn secondary" href="index.php?page=veiculos&edit=<?php echo $v['id_veiculo']; ?>">Editar</a>
                <a class="btn danger" href="index.php?page=veiculos&delete=<?php echo $v['id_veiculo']; ?>"
                   onclick="return confirm('Deseja realmente excluir este veículo?');">
                  Excluir
                </a>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
</div>
