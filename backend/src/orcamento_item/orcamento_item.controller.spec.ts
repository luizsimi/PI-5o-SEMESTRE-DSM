import { Test, TestingModule } from '@nestjs/testing';
import { OrcamentoItemController } from './orcamento_item.controller';
import { OrcamentoItemService } from './orcamento_item.service';

describe('OrcamentoItemController', () => {
  let controller: OrcamentoItemController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [OrcamentoItemController],
      providers: [OrcamentoItemService],
    }).compile();

    controller = module.get<OrcamentoItemController>(OrcamentoItemController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
